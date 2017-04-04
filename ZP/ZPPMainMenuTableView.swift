//
//  ZPPMainMenuTableView.swift
//  Academia
//
//  Created by Алексей on 04.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//
import Foundation
import UIKit

private let cellIdentifier = "ZPPMainMenuTableViewCell"
private let headerIdentifier = "ZPPMenuSectionSeparatorView"

@objc protocol ZPPMainMenuDelegate {
  func didSelectCategory(_ category: ZPPCategory)
  func didSelectProfile()
  func didSelectOrders()
  func didSelectHelp()
}

@objc class ZPPMainMenuTableView: UITableView {
  var categories: [ZPPCategory] = [] {
    didSet {
      reloadData()
    }
  }

  var ordersCount: Int = 0 {
    didSet {
      reloadRows(at: [IndexPath(row: AdditionalInfoRows.orders.rawValue, section: Sections.additionalInfo.rawValue)], with: .automatic)
    }
  }

  var balance: Int = 0 {
    didSet {
      reloadSections(IndexSet(integer: Sections.balance.rawValue), with: .automatic)
    }
  }

  var menuDelegate: ZPPMainMenuDelegate? = nil

  enum Sections: Int {
    case categories
    case additionalInfo
    case balance

    static let count = 3
  }

  enum AdditionalInfoRows: Int {
    case profile
    case orders
    case help

    static let count = 3

    var name: String {
      switch self {
      case .profile:
        return "Профиль"
      case .orders:
        return "Отзывы"
      case .help:
        return "Помощь"
      }
    }
  }


  init(frame: CGRect) {
    super.init(frame: frame, style: .grouped)
    backgroundColor = UIColor.black
    delegate = self
    dataSource = self
    separatorStyle = .none
    showsVerticalScrollIndicator = false

    register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    register(UINib(nibName: headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: headerIdentifier)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func show() {
    UIView.animate(withDuration: 0.4) {
      self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
  }

  func dismiss() {
    UIView.animate(withDuration: 0.4) {
      self.frame = CGRect(x: 0, y: -self.frame.size.height, width: self.frame.size.width, height: self.frame.size.height)
    }
  }
}



extension ZPPMainMenuTableView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case Sections.categories.rawValue:
      return categories.count
    case Sections.additionalInfo.rawValue:
      return AdditionalInfoRows.count
    default:
      return 0
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ZPPMainMenuTableViewCell
    switch indexPath.section {
    case Sections.categories.rawValue:
      cell.name = categories[indexPath.row].name
    case Sections.additionalInfo.rawValue:
      if ordersCount > 0, indexPath.row == AdditionalInfoRows.orders.rawValue {
        cell.name = "ЗАКАЗЫ (\(ordersCount))"
      }
      cell.name = AdditionalInfoRows(rawValue: indexPath.row)?.name
    case Sections.balance.rawValue:
      if balance > 0 {
        cell.name = "Текущий баланс: %@ бонусов"
      } else {
        cell.name = ""
      }
    default:
      break
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case Sections.categories.rawValue:
      menuDelegate?.didSelectCategory(categories[indexPath.row])
    case Sections.additionalInfo.rawValue:
      switch indexPath.row {
      case AdditionalInfoRows.profile.rawValue:
        menuDelegate?.didSelectProfile()
      case AdditionalInfoRows.orders.rawValue:
        menuDelegate?.didSelectOrders()
      case AdditionalInfoRows.help.rawValue:
        menuDelegate?.didSelectHelp()
      default:
        break
      }
    default:
      break
    }
  }
}

extension ZPPMainMenuTableView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard section == Sections.additionalInfo.rawValue || section == Sections.balance.rawValue
 else { return 0 }
    return 30
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard section == Sections.additionalInfo.rawValue else { return nil }
    return tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
  }
}

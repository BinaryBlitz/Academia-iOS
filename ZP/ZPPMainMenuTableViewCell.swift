//
//  ZPPMenuTableViewCell.swift
//  Academia
//
//  Created by Алексей on 04.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

import Foundation
import UIKit

class ZPPMainMenuTableViewCell: UITableViewCell {
  @IBOutlet weak var nameLabel: UILabel!

  var name: String? {
    get {
      return nameLabel.text
    }
    set {
      nameLabel.text = newValue?.uppercased()
    }
  }
}

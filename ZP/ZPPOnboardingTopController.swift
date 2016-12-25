//
//  ZPPOnboardingTopController.swift
//  ZP
//
//  Created by Andrey Mikhaylov on 18/02/16.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import UIKit
import EZSwipeController
import PureLayout

class ZPPOnboardingTopController: EZSwipeController {

    var bottomView: UIView?

    let btnHeight: CGFloat = 40
    fileprivate let descriptionLabels = [
        "Вкусная и полезная еда\nКаждый день новое меню",
        "Выбирай из набора ланчей: Diet Meal, Super Meal и Veggie meal",
        "Натуральные и свежие ингредиенты",
        "Все легко и быстро\nОплата картой в приложении",
        "Доставка за 30 минут"
    ]

    override func setupView() {
        datasource = self
        navigationBarShouldBeOnBottom = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        setNeedsStatusBarAppearanceUpdate()

        addButton()
    }

    func addButton() {

        let screenS = UIScreen.main.bounds.size
        let r = CGRect(x: 0 , y: screenS.height - btnHeight, width: screenS.width, height: btnHeight)
        let v = UIView(frame:r)

        v.backgroundColor = UIColor.black

        view.addSubview(v)

        view.bringSubview(toFront: v)

        let btn = UIButton(type: .custom)
        btn.setTitle("Пропустить", for: UIControlState())
        v.addSubview(btn)

        btn.setTitleColor(UIColor.lightGray, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .left


        btn.autoPinEdge(toSuperviewEdge: .left, withInset: 10)
        btn.autoPinEdge(toSuperviewEdge: .top)
        btn.autoPinEdge(toSuperviewEdge: .bottom)
        btn.autoSetDimension(.width, toSize: 100)

        btn.addTarget(self, action: #selector(skip), for: .touchUpInside)


        let rbtn = UIButton(type: .custom)
        let img = UIImage(named: "forwardArror")
//        rbtn.setTitle("Далее", forState: .Normal)
        rbtn.setImage(img, for: UIControlState())
        rbtn.contentHorizontalAlignment = .right

        v.addSubview(rbtn)
        rbtn.autoPinEdge(toSuperviewEdge: .right, withInset: 10)
        rbtn.autoPinEdge(toSuperviewEdge: .top)
        rbtn.autoPinEdge(toSuperviewEdge: .bottom)
        rbtn.autoSetDimension(.width, toSize: 30)

        rbtn.addTarget(self, action: #selector(moveForward), for: .touchUpInside)
    }


    func moveForward() {
        if currentStackVC == stackPageVC.last {
            skip()
            return
        }

        rightButtonAction()
    }

    func skip() {
        dismiss(animated: true, completion: nil)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent;
    }
}

extension ZPPOnboardingTopController: EZSwipeControllerDataSource {

    func viewControllerData() -> [UIViewController] {
        let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)

        return descriptionLabels.enumerated().map { (index, label) -> ZPPOnboardingVC in
            let item = onboardingStoryboard.instantiateViewController(withIdentifier: ZPPOnboardingVCID) as! ZPPOnboardingVC
            let str = "Phone\(index + 1).png"
            let backStr = "back-\(index + 1).jpg"
            item.configure(backStr, iphoneName: str, text: label)
            return item
        }
    }
}

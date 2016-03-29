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
    private let descriptionLabels = [
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

        view.backgroundColor = UIColor.blackColor()
        setNeedsStatusBarAppearanceUpdate()
        
        addButton()
    }
    
    func addButton() {
        
        let screenS = UIScreen.mainScreen().bounds.size
        let r = CGRect(x: 0 , y: screenS.height - btnHeight, width: screenS.width, height: btnHeight)
        let v = UIView(frame:r)
        
        v.backgroundColor = UIColor.blackColor()
        
        view.addSubview(v)
        
        view.bringSubviewToFront(v)
        
        let btn = UIButton(type: .Custom)
        btn.setTitle("Пропустить", forState: .Normal)
        v.addSubview(btn)
        
        btn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.contentHorizontalAlignment = .Left
        
        
        btn.autoPinEdgeToSuperviewEdge(.Left, withInset: 10)
        btn.autoPinEdgeToSuperviewEdge(.Top)
        btn.autoPinEdgeToSuperviewEdge(.Bottom)
        btn.autoSetDimension(.Width, toSize: 100)
        
        btn.addTarget(self, action: #selector(skip), forControlEvents: .TouchUpInside)
        
        
        let rbtn = UIButton(type: .Custom)
        let img = UIImage(named: "forwardArror")
//        rbtn.setTitle("Далее", forState: .Normal)
        rbtn.setImage(img, forState: .Normal)
        rbtn.contentHorizontalAlignment = .Right
        
        v.addSubview(rbtn)
        rbtn.autoPinEdgeToSuperviewEdge(.Right, withInset: 10)
        rbtn.autoPinEdgeToSuperviewEdge(.Top)
        rbtn.autoPinEdgeToSuperviewEdge(.Bottom)
        rbtn.autoSetDimension(.Width, toSize: 30)
        
        rbtn.addTarget(self, action: #selector(moveForward), forControlEvents: .TouchUpInside)
    }
    
    
    func moveForward() {
        if currentStackVC == stackPageVC.last {
            skip()
            return
        }
        
        rightButtonAction()
    }
    
    func skip() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent;
    }
}

extension ZPPOnboardingTopController: EZSwipeControllerDataSource {
    
    func viewControllerData() -> [UIViewController] {
        let onboardingStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        return descriptionLabels.enumerate().map { (index, label) -> ZPPOnboardingVC in
            let item = onboardingStoryboard.instantiateViewControllerWithIdentifier(ZPPOnboardingVCID) as! ZPPOnboardingVC
            let str = "Phone\(index + 1).png"
            let backStr = "back-\(index + 1).jpg"
            item.configure(backStr, iphoneName: str, text: label)
            return item
        }
    }
}
//
//  ZPPOnboardingTopController.swift
//  ZP
//
//  Created by Andrey Mikhaylov on 18/02/16.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

//import UIKit
import EZSwipeController

import PureLayout

class ZPPOnboardingTopController: EZSwipeController {

    var bottomView:UIView?
    
    let btnHeight:CGFloat = 40
    
    override func setupView() {
        datasource = self
        navigationBarShouldBeOnBottom = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.blackColor()
        self.setNeedsStatusBarAppearanceUpdate()
        
        self.addButton()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addButton() {
        
        let screenS = UIScreen.mainScreen().bounds.size
        let r = CGRect(x:0 , y: screenS.height - btnHeight, width: screenS.width, height: btnHeight)
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
        
        btn.addTarget(self, action: "skip", forControlEvents: .TouchUpInside)
        
        
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
        
        rbtn.addTarget(self, action: "moveForvard", forControlEvents: .TouchUpInside)
        
        
    }
    
    
    func moveForvard() {
//        let currentPage = currentVCIndex
        if currentStackVC == stackPageVC.last {
            skip()
            return
        }
        
        self.clickedRightButton()
    }
    
    func skip() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ZPPOnboardingTopController: EZSwipeControllerDataSource {
    func viewControllerData() -> [UIViewController] {
        
        let sb = UIStoryboard(name: "Onboarding", bundle: nil)
        let first = sb.instantiateViewControllerWithIdentifier(ZPPOnboardingVCID) as! ZPPOnboardingVC
        let second = sb.instantiateViewControllerWithIdentifier(ZPPOnboardingVCID) as! ZPPOnboardingVC
        let third = sb.instantiateViewControllerWithIdentifier(ZPPOnboardingVCID) as! ZPPOnboardingVC
        let fourth = sb.instantiateViewControllerWithIdentifier(ZPPOnboardingVCID) as! ZPPOnboardingVC
        let fifth = sb.instantiateViewControllerWithIdentifier(ZPPOnboardingVCID) as! ZPPOnboardingVC
        let vcs = [first, second, third, fourth, fifth]
        
        let texts = ["Вкусная и полезная еда\nКаждый день новое меню",
                     "Выбирай из набора ланчей: Diet Meal, Super Meal и Veggie meal",
                     "Натуральные и свежие ингредиенты",
                     "Все легко и быстро\nОплата картой в приложении",
                     "Доставка за 30 минут"]
        
        for (i, item) in vcs.enumerate() {
            let str = "Phone\(i+1).png"
            let backStr = "back-\(i+1).jpg"
            let text = texts[i]
            item.configure(backStr, iphoneName: str, text: text)
            
        }
        
//        first.configure("", iphoneName: "", text: "")
        
        
      
        
        return vcs
    }
}
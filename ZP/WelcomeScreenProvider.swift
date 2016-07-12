//
//  WelcomeScreenProvider.swift
//  ZP
//
//  Created by Dan Shevlyuk on 07/04/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

import Foundation

@objc class WelcomeScreenProvider: NSObject {
    
    static var sharedProvider = WelcomeScreenProvider()
    
    var imageURLString: String?
    var imageURL: NSURL? {
        return NSURL(string: (imageURLString ?? ""))
    }
    var hasAvailableScreen: Bool {
        return imageURLString != nil
    }
}

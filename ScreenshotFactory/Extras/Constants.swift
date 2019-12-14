//
//  Constants.swift
//  ScreenshotFactory
//
//  Created by Filip Němeček on 10/09/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

enum R {
    struct Images {
        struct Frames {
            static let iPhoneX = "iPhoneXS_Max_frame.png"
            static let iPhone8Plus = "iphone8-Plus-frame.png"
        }
        static let demoScreenshot = "demo-screenshot.png"
        static let classicDemoScreenshot = "classic-demo-screenshot.png"
    }
    struct Segues {
        static let showPreview = "showPreview"
    }
    static let DefaultFontName = "HelveticaNeue-Thin"
    
    static let PrettyColors: [UIColor] = [.black, .darkGray,
                                          UIColor(red: 0.043, green: 0.239, blue: 0.718, alpha: 1.00),
                                          UIColor(red: 0.231, green: 0.569, blue: 0.745, alpha: 1.00),
                                          UIColor(red: 0.675, green: 0.133, blue: 0.090, alpha: 1.00),
                                          .orange,
                                          UIColor(red: 0.329, green: 0.718, blue: 0.259, alpha: 1.00),
                                          UIColor(red: 0.506, green: 0.106, blue: 0.408, alpha: 1.00),
                                          UIColor(red: 0.980, green: 0.847, blue: 0.286, alpha: 1.00),
    ]
}

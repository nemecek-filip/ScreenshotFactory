//
//  iPhone.swift
//  ScreenshotFactory
//
//  Created by Filip Němeček on 17/09/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

struct iPhone {
    let resultSize: CGSize
    let phoneFrame: CGRect
    let screenshotFrame: CGRect
    let textFrame: CGRect
    
    let image: UIImage
    
    init(resultSize: CGSize, sideFrameMargin: CGFloat, textSpaceHeight: CGFloat, aspectRatio: CGFloat, screenshotInset: CGFloat, imageName: String) {
        self.resultSize = resultSize
        let phoneFrameWidth: CGFloat = resultSize.width - 2 * sideFrameMargin
        phoneFrame = CGRect(x: sideFrameMargin, y: textSpaceHeight, width: phoneFrameWidth, height: phoneFrameWidth * aspectRatio)
        screenshotFrame = phoneFrame.insetBy(dx: screenshotInset, dy: screenshotInset)
        
        textFrame = CGRect(x: sideFrameMargin, y: sideFrameMargin * 2, width: resultSize.width - 2 * sideFrameMargin, height: textSpaceHeight)
        
        image = UIImage(named: imageName)!
    }
    
    static let X = iPhone(resultSize: CGSize(width: 1125, height: 2436), sideFrameMargin: 30, textSpaceHeight: 600, aspectRatio: 19.5 / 9, screenshotInset: 82, imageName: R.Images.Frames.iPhoneX)
    
}

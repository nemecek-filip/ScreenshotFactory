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
    let width: CGFloat
    let aspectRatio: CGFloat
    
    let frameImage: UIImage
    
    private let screenshotFrame: CGRect
    
    init(resultSize: CGSize, width: CGFloat, aspectRatio: CGFloat, imageName: String, screenshotWidth: CGFloat, screenshotTopOffset: CGFloat) {
        self.resultSize = resultSize
        self.width = width
        self.frameImage = UIImage(named: imageName)!
        self.aspectRatio = aspectRatio
        
        self.screenshotFrame = CGRect(x: (width - screenshotWidth) / 2, y: screenshotTopOffset, width: screenshotWidth, height: screenshotWidth * aspectRatio)
    }
    
    func render(with screenshot: UIImage? = nil) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: width * aspectRatio))
        
        return renderer.image { (ctx) in
            if let screenshot = screenshot {
                screenshot.draw(in: self.screenshotFrame)
            }
            
            frameImage.draw(in: CGRect(x: 0, y: 0, width: width, height: width * aspectRatio))
        }
    }
    
    static let X = iPhone(resultSize: CGSize(width: 1242, height: 2688), width: 1180, aspectRatio: 19.5 / 9, imageName: R.Images.Frames.iPhoneX, screenshotWidth: 1022, screenshotTopOffset: 78)
    
}

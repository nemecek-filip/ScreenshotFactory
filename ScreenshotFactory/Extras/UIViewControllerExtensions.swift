//
//  UIViewControllerExtensions.swift
//  ScreenshotFactory
//
//  Created by Filip Němeček on 14/12/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

extension UIViewController {
    func share(image: UIImage?, from view: UIView?, from barButton: UIBarButtonItem?) {
        precondition(view != nil || barButton != nil, "You must provide either view or barButton")
        guard let image = image else { return }
        let shareController = UIActivityViewController(activityItems: ["ScrenshotFactory" as String, image as Any], applicationActivities: nil)
        if let view = view {
            shareController.popoverPresentationController?.sourceView = view
            shareController.popoverPresentationController?.sourceRect = view.bounds
        } else {
            shareController.popoverPresentationController?.barButtonItem = barButton
        }
        present(shareController, animated: true, completion: nil)
    }
}

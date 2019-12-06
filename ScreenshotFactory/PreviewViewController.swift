//
//  PreviewViewController.swift
//  ScreenshotFactory
//
//  Created by Filip Němeček on 06/12/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    @IBOutlet var previewImageView: UIImageView!
    
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewImageView.image = image
    }
    
    @IBAction func exportButtonTapped(_ sender: UIBarButtonItem) {
        share(image: previewImageView.image, from: nil, from: sender)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

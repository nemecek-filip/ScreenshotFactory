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

        // Do any additional setup after loading the view.
        
        previewImageView.image = image
    }
    
    @IBAction func exportButtonTapped(_ sender: UIBarButtonItem) {
        share(image: previewImageView.image, from: nil, from: sender)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

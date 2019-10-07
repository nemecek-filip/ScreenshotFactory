//
//  ViewController.swift
//  ScreenshotFactory
//
//  Created by Filip Němeček on 10/09/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var resultImageView: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var sourceTextView: UITextView!
    @IBOutlet var textSizeSlider: UISlider!
    
    let phone = iPhone.X
    
    let colors: [UIColor] = [.black, .darkGray, .blue, .red, .orange, .green, .magenta]
    
    let demoScreenshot = UIImage(named: R.Images.demoScreenshot)!
    
    var selectedScreenshot: UIImage? {
        didSet {
            redraw(animated: true)
        }
    }
    var backgroundColor = UIColor.lightGray
    var textToRender: String?
    var textSize: CGFloat = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        sourceTextView.delegate = self
        
        setupViews()
        setupGestureRecognizer()
        
        textToRender = sourceTextView.text
        selectedScreenshot = demoScreenshot
        
        redraw()
    }
    
    func setupViews() {
        resultImageView.layer.shadowColor = UIColor.black.cgColor
        resultImageView.layer.shadowOpacity = 0.5
        resultImageView.layer.shadowOffset = .zero
        resultImageView.layer.shadowRadius = 10
    }
    
    func setupGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        resultImageView.addGestureRecognizer(recognizer)
    }
    
    @IBAction func exportButtonTapped(_ sender: UIButton) {
        let shareController = UIActivityViewController(activityItems: [resultImageView.image as Any], applicationActivities: nil)
        shareController.popoverPresentationController?.sourceView = sender
        shareController.popoverPresentationController?.sourceRect = sender.bounds
        present(shareController, animated: true, completion: nil)
    }
    
    
    @objc func imageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let newImage = info[.originalImage] as? UIImage else {
            return
        }
        
        selectedScreenshot = newImage
        
        dismiss(animated: true, completion: nil)
    }

    func redraw(animated: Bool = false) {
        let renderer = UIGraphicsImageRenderer(size: phone.resultSize)
        
        let animationDuration = animated ? 0.1 : 0
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.resultImageView.alpha = 0.2
        }) { (finished) in
            let img = renderer.image { ctx in
                
                ctx.cgContext.setFillColor(self.backgroundColor.cgColor)
                ctx.cgContext.addRect(CGRect(origin: CGPoint.zero, size: self.phone.resultSize))
                ctx.cgContext.drawPath(using: .fillStroke)
                
                if let screenshotImage = self.selectedScreenshot {
                    screenshotImage.draw(in: self.phone.screenshotFrame)
                }
                
                self.phone.image.draw(in: self.phone.phoneFrame)
                
                if let text = self.textToRender {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: self.textSize)!, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.white]
                    
                    text.draw(with: self.phone.textFrame, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
                }
            }
            
            self.resultImageView.image = img
            
            UIView.animate(withDuration: animationDuration, animations: {
                self.resultImageView.alpha = 1
            })
        }
    }
    
    @IBAction func textSizeSliderValueChanged(_ sender: UISlider) {
        textSize = CGFloat(sender.value)
        redraw(animated: true)
    }
}

// MARK: Collection View delegate

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        
        cell.backgroundColor = colors[indexPath.item]
        
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        backgroundColor = colors[indexPath.item]
        redraw(animated: true)
    }
}

// MARK: Text View delegate

extension ViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textToRender = textView.text
        redraw()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

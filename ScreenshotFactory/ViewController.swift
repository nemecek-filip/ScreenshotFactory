//
//  ViewController.swift
//  ScreenshotFactory
//
//  Created by Filip Němeček on 10/09/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var deviceSegmentedControl: UISegmentedControl!
    @IBOutlet var resultImageView: UIImageView!
    @IBOutlet var notchResultImageViewAspectRatioConstraint: NSLayoutConstraint!
    @IBOutlet var classicResultImageViewAspectRatioConstraint: NSLayoutConstraint!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var sourceTextView: UITextView!
    @IBOutlet var textSizeSlider: UISlider!
    @IBOutlet var fontPickerView: FontPickerView!
    @IBOutlet var previewButton: UIButton!
    @IBOutlet var exportButton: UIButton!
    
    var aspectRatioConstraints: [NSLayoutConstraint] {
        return [classicResultImageViewAspectRatioConstraint, notchResultImageViewAspectRatioConstraint]
    }
    
    var phone = iPhone.X
    
    let colors: [UIColor] = R.PrettyColors
    
    var demoScreenshot: UIImage {
        if deviceSegmentedControl.selectedSegmentIndex == 0 {
            return UIImage(named: R.Images.classicDemoScreenshot)!
        } else {
            return UIImage(named: R.Images.demoScreenshot)!
        }
    }
    
    var selectedScreenshot: UIImage? {
        didSet {
            redraw(animated: true)
        }
    }
    var backgroundColor = UIColor.darkGray
    var textToRender: String?
    var textSize: CGFloat = 140
    var font: FontPickerView.FontModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        sourceTextView.delegate = self
        
        fontPickerView.didSelectFont = newFontSelected(_:)
        
        setupViews()
        setupGestureRecognizer()
        
        textToRender = sourceTextView.text
        selectedScreenshot = demoScreenshot
        
        redraw()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.Segues.showPreview {
            guard let nvc = segue.destination as? UINavigationController, let previewVC = nvc.topViewController as? PreviewViewController else {
                fatalError()
            }
            previewVC.image = resultImageView.image
        }
    }
    
    func newFontSelected(_ font: FontPickerView.FontModel) {
        self.font = font
        redraw()
    }
    
    func setupViews() {
        resultImageView.applyLightShadow()
        previewButton.applyMediumShadow()
        exportButton.applyLightShadow()
    }
    
    func setupGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        resultImageView.addGestureRecognizer(recognizer)
    }
    
    @IBAction func exportButtonTapped(_ sender: UIButton) {
        share(image: resultImageView.image, from: sender, from: nil)
    }
    
    @IBAction func previewButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: R.Segues.showPreview, sender: self)
    }
    
    @IBAction func deviceTypeSegmentedControlChanged(_ sender: UISegmentedControl) {
        guard sender.selectedSegmentIndex != 2 else { return } // temp measure
        selectedScreenshot = demoScreenshot
        
        sender.isUserInteractionEnabled = false
        aspectRatioConstraints.forEach({ $0.isActive = false })
        
        if sender.selectedSegmentIndex == 0 {
            phone = .EightPlus
            classicResultImageViewAspectRatioConstraint.isActive = true
        } else if sender.selectedSegmentIndex == 1 {
            phone = .X
            notchResultImageViewAspectRatioConstraint.isActive = true
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.resultImageView.layoutIfNeeded()
            self.resultImageView.alpha = 0.1
        }) { (_) in
            self.redraw(animated: false)
            UIView.animate(withDuration: 0.2, animations: {
                self.resultImageView.alpha = 1
            }) { (_) in
                sender.isUserInteractionEnabled = true
            }
        }
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
        
        let animationDuration = animated ? 0.2 : 0
        
        let img = renderer.image { ctx in
            
            ctx.cgContext.setFillColor(self.backgroundColor.cgColor)
            ctx.cgContext.addRect(CGRect(origin: CGPoint.zero, size: self.phone.resultSize))
            ctx.cgContext.drawPath(using: .fillStroke)
            
            let phoneWidth = self.phone.resultSize.width - 2 * 50
            self.phone.render(with: self.selectedScreenshot).draw(in: CGRect(x: 50, y: 500, width: phoneWidth, height: phoneWidth * self.phone.aspectRatio))
            
            if let text = self.textToRender {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                
                let font: UIFont
                if let selectedFont = self.font {
                    font = UIFont(name: selectedFont.identifier, size: self.textSize)!
                } else {
                    font = UIFont(name: R.DefaultFontName, size: self.textSize)!
                }
                
                let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.white]
                
                text.draw(with: CGRect(x: 20, y: 20, width: self.phone.resultSize.width - 2 * 20, height: 480), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            }
        }
        
        if animated {
            UIView.animate(withDuration: animationDuration, animations: {
                self.resultImageView.alpha = 0.2
            }) { (finished) in
                
                
                self.resultImageView.image = img
                
                UIView.animate(withDuration: animationDuration, animations: {
                    self.resultImageView.alpha = 1
                })
            }
        } else {
            resultImageView.image = img
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

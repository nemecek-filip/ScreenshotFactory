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
    @IBOutlet var fontPickerView: FontPickerView!
    
    let phone = iPhone.X
    
    let colors: [UIColor] = [.black, .darkGray,
                             UIColor(red: 0.043, green: 0.239, blue: 0.718, alpha: 1.00),
                             UIColor(red: 0.231, green: 0.569, blue: 0.745, alpha: 1.00),
                             UIColor(red: 0.675, green: 0.133, blue: 0.090, alpha: 1.00),
                             .orange,
                             UIColor(red: 0.329, green: 0.718, blue: 0.259, alpha: 1.00),
                             UIColor(red: 0.506, green: 0.106, blue: 0.408, alpha: 1.00),
                             UIColor(red: 0.980, green: 0.847, blue: 0.286, alpha: 1.00),
    ]
    
    let demoScreenshot = UIImage(named: R.Images.demoScreenshot)!
    
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
        if segue.identifier == "showPreview" {
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
        share(image: resultImageView.image, from: sender, from: nil)
    }
    
    @IBAction func previewButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showPreview", sender: self)
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
                
                let phoneWidth = self.phone.resultSize.width - 2 * 50
                self.phone.render(with: self.selectedScreenshot).draw(in: CGRect(x: 50, y: 500, width: phoneWidth, height: phoneWidth * self.phone.aspectRatio))
                
                if let text = self.textToRender {
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    
                    let font: UIFont
                    if let selectedFont = self.font {
                        font = UIFont(name: selectedFont.identifier, size: self.textSize)!
                    } else {
                        font = UIFont(name: "HelveticaNeue-Thin", size: self.textSize)!
                    }
                    
                    let attrs = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.white]
                    
                    text.draw(with: CGRect(x: 20, y: 20, width: self.phone.resultSize.width - 2 * 20, height: 480), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
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

extension UIViewController {
    func share(image: UIImage?, from view: UIView?, from barButton: UIBarButtonItem?) {
        precondition(view != nil || barButton != nil, "You must provide either view or barButton")
        guard let image = image else { return }
        let shareController = UIActivityViewController(activityItems: [image as Any], applicationActivities: nil)
        if let view = view {
            shareController.popoverPresentationController?.sourceView = view
            shareController.popoverPresentationController?.sourceRect = view.bounds
        } else {
            shareController.popoverPresentationController?.barButtonItem = barButton
        }        
        present(shareController, animated: true, completion: nil)
    }
}

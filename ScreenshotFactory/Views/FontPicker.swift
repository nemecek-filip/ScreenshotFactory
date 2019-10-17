//
//  FontPicker.swift
//  ScreenshotFactory
//
//  Created by Filip Němeček on 17/10/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

@IBDesignable class FontPickerView: UIView, UITableViewDataSource, UITableViewDelegate {
    struct FontModel {
        let font: String
        let name: String
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var didSelectFont: ((FontModel) -> Void)?
    
    private let fontIdentifiers = [
        "AvenirNext-Regular",
        "AmericanTypewriter",
        "HelveticaNeue-Thin"
    ]
    
    private let fontNames = [
        "Avenir Next",
        "American Typewriter",
        "Helvetica Neue Thin"
    ]
    
    private var fontModels = [FontModel]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let fontModel = fontModels[indexPath.row]
        cell.textLabel?.font = UIFont(name: fontModel.font, size: 16)!
        cell.textLabel?.text = "ABCDEFGH"
        cell.backgroundColor = .clear
        cell.detailTextLabel?.text = fontModel.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectFont?(fontModels[indexPath.row])
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        for (index, fontIdentifier) in fontIdentifiers.enumerated() {
            fontModels.append(FontPickerView.FontModel(font: fontIdentifier, name: fontNames[index]))
        }
        
        addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

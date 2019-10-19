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
        let identifier: String
        let name: String
        let font: UIFont
        
        init(name: String, identifier: String) {
            self.name = name
            self.identifier = identifier
            self.font = UIFont(name: identifier, size: 16)!
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    var didSelectFont: ((FontModel) -> Void)?
    
    private let fontIdentifiers = [
        "AvenirNext-Regular",
        "AmericanTypewriter",
        "Courier",
        "HelveticaNeue-Thin",
        "Menlo-Bold",
        "Noteworthy-Light",
        "Palatino-Roman",
    ]
    
    private let fontNames = [
        "Avenir Next",
        "American Typewriter",
        "Courier",
        "Helvetica Neue",
        "Menlo",
        "Noteworthy",
        "Palatino",
    ]
    
    private var fontModels = [FontModel]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fontModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FontCell else {
            fatalError()
        }
        
        let fontModel = fontModels[indexPath.row]
        cell.configure(with: fontModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectFont?(fontModels[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = .clear // To fix white background
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
        backgroundColor = .clear
        
        assert(fontNames.count == fontIdentifiers.count, "Improperly setup fonts")
        
        for (index, fontIdentifier) in fontIdentifiers.enumerated() {
            fontModels.append(FontPickerView.FontModel(name: fontNames[index], identifier: fontIdentifier))
        }
        
        addSubview(tableView)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FontCell", bundle: bundle)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
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

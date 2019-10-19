//
//  FontCell.swift
//  ScreenshotFactory
//
//  Created by Filip Němeček on 19/10/2019.
//  Copyright © 2019 Filip Němeček. All rights reserved.
//

import UIKit

class FontCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
    }

    func configure(with fontModel: FontPickerView.FontModel) {
        titleLabel.font = fontModel.font
        subtitleLabel.text = fontModel.name
    }
    
}

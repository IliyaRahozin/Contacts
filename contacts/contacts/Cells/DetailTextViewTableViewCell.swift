//
//  DetailTextViewTableViewCell.swift
//  contacts
//
//  Created by Iliya Rahozin on 15.06.2022.
//

import UIKit

class DetailTextViewTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var upperDescriptionLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet weak var bottomLine: UIView!
    
    static let identifier = "DetailTextViewTableViewCell"
    var isLast: Bool = false {
        didSet {
            //lineSeparator()
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpperDescriptionLabel(with text: String?) {
        guard let text = text else { return }
        upperDescriptionLabel.text = text
    }
    
    func setTextViewText(with text: String?) {
        if text != nil {
            self.isHidden = false
            textView.text = text
        } else {
            self.isHidden = true
            textView.text = nil
        }
    }
    
    func lineSeparator() {
        if isLast {
            bottomLine.isHidden = false
            bottomLine.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        } else {
            bottomLine.isHidden = true
        }
    }
    
}

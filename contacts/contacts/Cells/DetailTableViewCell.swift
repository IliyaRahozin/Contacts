//
//  DetailTableViewCell.swift
//  contacts
//
//  Created by Iliya Rahozin on 14.06.2022.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var upperDescriptionLabel: UILabel!
    @IBOutlet private weak var contactInfoLabel: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    
    static let identifier = "DetailTableViewCell"
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpperDescriptionLabel(with text: String?) {
        guard let text = text else { return }
        upperDescriptionLabel.text = text
    }
    
    func setContactInfoLabel(with text: String?) {
        if text != nil {
            contactInfoLabel.text = text
        } else {
            contactInfoLabel.text = nil
        }
    }
    
    func lineSeparator() {
        if isLast {
            bottomLine.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
        }
    }
}

//
//  ContactTableViewCell.swift
//  contacts
//
//  Created by Iliya Rahozin on 10.06.2022.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet private weak var contactImage: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var lowerInfoLabel: UILabel!
    
    let defaultImage = UIImage(named: "person.crop.circle.fill")
    static let identifier = "ContactTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contactImage.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContactImage(image: UIImage?) {
        contactImage.image = image ?? defaultImage
        setDefaultImgTint()
        setRounded()
    }
    
    private func setDefaultImgTint() {
        if contactImage.image == defaultImage {
            if #available(iOS 13.0, *) {
                contactImage.tintColor = .systemGray2
            } else {
                contactImage.tintColor = UIColor(red: 0.60, green: 0.60, blue: 0.64, alpha: 1.00)
            }
        } else {
            contactImage.tintColor = .none
        }
    }
    
    func setFullNameLabel(text: String?) {
        fullNameLabel.text = text
    }
    
    func setLowerInfoLabel(text: String?) {
        lowerInfoLabel.text = text
    }
    
    private func setRounded() {
        contactImage.layer.masksToBounds = true
        contactImage.layer.cornerRadius =  contactImage.frame.width / 2
    }
    
}

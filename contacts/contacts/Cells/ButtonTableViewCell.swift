//
//  ButtonTableViewCell.swift
//  contacts
//
//  Created by Iliya Rahozin on 01.06.2022.
//

import UIKit

protocol ButtonCellDelegate: AnyObject {
    func buttonDidTapped()
}

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var button: UIButton!
    @IBOutlet weak var topLine: UIView!
    
    var type: CellType?
    var isLast: Bool = false {
        didSet {
            lineSeparetor()
        }
    }
    weak var delegate: ButtonCellDelegate?
    
    static let identifier = "ButtonTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setButtonEnable()
    }
    
    func setbuttonTitleLabel(with title: String) {
        button.setTitle(title, for: .normal)
    }
    
    func setButtonEnable(with state: Bool = true) {
        button.isEnabled = state
    }
    
    func lineSeparetor() {
        topLine.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.buttonDidTapped()
    }
}

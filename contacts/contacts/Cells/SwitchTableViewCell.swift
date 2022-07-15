//
//  SwitchTableViewCell.swift
//  contacts
//
//  Created by Iliya Rahozin on 01.06.2022.
//

import UIKit

protocol SwitchCellDelegate: AnyObject {
    func switchDidChanges (_ cell: SwitchTableViewCell, state: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var switcher: UISwitch!
    @IBOutlet private weak var line: UIView!
    
    var type: CellType?
    weak var delegate: SwitchCellDelegate?
    
    static let identifier = "SwitchTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLeftTextLabel(with text: String){
        leftLabel.text = text
    }
    
    func switchTurnOn(state: Bool = true){
        switcher.isOn = state
    }
    func switchIsOn() -> Bool {
        return switcher.isOn ? true : false 
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        delegate?.switchDidChanges(self, state: sender.isOn)
    }
    
}

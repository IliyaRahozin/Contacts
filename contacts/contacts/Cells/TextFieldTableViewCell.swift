//
//  TextFieldTableViewCell.swift
//  contacts
//
//  Created by Iliya Rahozin on 01.06.2022.
//

import UIKit

protocol TextFieldCellDelegate: AnyObject {
    func checkOptionalTextFields(_ cell: TextFieldTableViewCell)
    func didChangeText(_ type: CellType?, _ cell: TextFieldTableViewCell)
}

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var line: UIView!
    
    @IBOutlet weak var leftPaddingLine: NSLayoutConstraint!
    @IBOutlet weak var rightPaddingLine: NSLayoutConstraint!
    
    var type: CellType?
    var isLast: Bool = false {
        didSet {
            lineLayout()
        }
    }
    weak var delegate: TextFieldCellDelegate?
    
    static let identifier = "TextFieldTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputTextField.delegate = self
        lineDefaultColor()
    }
    
    //MARK: Setters
    func setLeftTextLabel(with text: String){
        leftLabel.text = text
    }
    
    func resetTextField() {
        inputTextField.text = nil
        inputTextField.endEditing(true)
    }
    
    func settextFieldPlaceholder(with placeholder: String){
        inputTextField.placeholder = placeholder
    }
    
    func setElementsActive() {
        leftLabel.textColor = .systemBlue
        line.backgroundColor = .systemBlue
    }

    func setElementsUnactivte() {
        leftLabel.textColor = .black
        lineDefaultColor()
    }
    
    func setInputTextField(text: String?) {
        guard let text = text else { return }
        inputTextField.text = text
        delegate?.checkOptionalTextFields(self)
    }
    
    func setErrorLabel(error: String?) {
        guard let error = error else {
            errorLabel.text = nil
            return
        }
        errorLabel.text = error
    }
    
    //MARK: - Getters
    func getTextFiledText() -> String? {
        guard let text = inputTextField.text else { return nil }
        if text == ""{
            return nil
        } else {
            return text
        }
    }
    
    func lineLayout() {
        if isLast {
            leftPaddingLine.constant = 0
            rightPaddingLine.constant = 0
        }
    }
    
    //MARK: Additional methods
    private func lineDefaultColor() {
        if #available(iOS 13.0, *) {
            line.backgroundColor = .systemGroupedBackground
        } else {
            line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
        }
    }
    
    func textFieldIsEmpty() -> Bool {
        if let text = inputTextField.text, !text.isEmpty {
            return false
        }
        return true
    }
    
    @IBAction func textFieldTapped(_ sender: UITextField) {
        guard let type = type else { return }
            if type == .phoneNumber {
                if validatePhoneNumber() != nil {
                    sender.text = nil
                }
        }
        delegate?.didChangeText(type, self)
        delegate?.checkOptionalTextFields(self)
    }
    
}


extension TextFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setElementsActive()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setElementsUnactivte()
    }
    
}

// MARK: - Validation
extension TextFieldTableViewCell {
    
    func validateTextField() -> String? {
        switch type {
        case .firstName, .lastName:
            return validateNames()
        case .phoneNumber:
            return validatePhoneNumber()
        case .email:
            return validateEmail()
        default:
            return nil
        }
    }
    
    private func validateNames() -> String? {
        let text = getTextFiledText()
        let maxSize = 30
        if let text = text {
            if let errorMessage = invalidSpaces(text: text, maxSize: maxSize) {
                return errorMessage
            } else {
                delegate?.didChangeText(type, self)
                return nil
            }
        } else {
            delegate?.didChangeText(type, self)
            return nil
        }
    }
    
    private func validatePhoneNumber() -> String? {
            let text = getTextFiledText()
            let maxSize = 30
            let regex = "^[+]+[0-9]{0,30}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            
            if text != nil {
                if !predicate.evaluate(with: text) {
                    let error = "Phone number format: “+12124567890”"
                    setErrorLabel(error: error)
                    setInputTextField(text: nil)
                    return error
                } else if let error = invalidSize(text: text, maxSize: maxSize) {
                    setErrorLabel(error: error)
                    let trimmed = String(text!.prefix(maxSize))
                    setInputTextField(text: trimmed)
                    delegate?.didChangeText(type, self)
                    return nil
                }else {
                    setErrorLabel(error: nil)
                    delegate?.didChangeText(type, self)
                    return nil
                }
            } else {
                setErrorLabel(error: nil)
                delegate?.didChangeText(type, self)
                return nil
            }
        }
    
    private func validateEmail() -> String? {
        let text = getTextFiledText()
        let regex = "^[^@\\s]+@[^@\\s\\.]+\\.[^@\\.\\s]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if text != nil {
            if !predicate.evaluate(with: text) {
                let error = "Enter email in format:name@example.com"
                setErrorLabel(error: error)
                return error
            } else {
                setErrorLabel(error: nil)
                delegate?.didChangeText(type, self)
                return nil
            }
        } else {
            setErrorLabel(error: nil)
            delegate?.didChangeText(type, self)
            return nil
        }
    }
    
    private func invalidSize(text: String?, maxSize: Int) -> String? {
        guard let text = text else {
            setErrorLabel(error: nil)
            return nil
        }
        if text.count >= maxSize {
            let error = "Max \(maxSize) characters"
            setErrorLabel(error: error)
            return error
        } else {
            setErrorLabel(error: nil)
            return nil
        }
    }
        
    private func invalidSpaces(text: String, maxSize: Int) -> String? {
        let trimmed: String? =  text.removeWhitespace() == "" ? nil : text.removeWhitespace()
        
        if let error = invalidSize(text: trimmed, maxSize: maxSize){
            setErrorLabel(error: error)
            setInputTextField(text: trimmed)
            return error
        } else if trimmed == nil {
            let error = "Enter 0-20 characters (not space bars only)"
            setErrorLabel(error: error)
            inputTextField.text = nil
            setCursorAtBeginning()
            return error
        } else {
            setInputTextField(text: trimmed)
            return nil
        }
    }
    
    private func setCursorAtBeginning() {
        let newPosition = inputTextField.beginningOfDocument
        inputTextField.selectedTextRange = inputTextField.textRange(from: newPosition, to: newPosition)
    }
}


extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
  }

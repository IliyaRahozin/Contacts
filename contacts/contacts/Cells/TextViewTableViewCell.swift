//
//  TextViewTableViewCell.swift
//  contacts
//
//  Created by Iliya Rahozin on 01.06.2022.
//

import UIKit

protocol TextViewCellDelegate: AnyObject {
    func textViewDidChangeSize()
    func textViewDidEnd(_ type: CellType, _ cell: TextViewTableViewCell)
}

class TextViewTableViewCell: UITableViewCell {

    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    
    var type: CellType?
    weak var delegate: TextViewCellDelegate?
    private let placeholderText = "Notes"
    
    static let identifier = "TextViewTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        setTextViewPlaceholder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setLeftTextLabel(with text: String) {
        leftLabel.text = text
    }
    
    func setTextViewText(text: String) {
        textView.text = text
        optionalTextViewPlaceholder()
    }
    
    func getPlaceholderText() -> String {
        return placeholderText
    }
    
    func getTextViewText() -> String? {
        guard let text = textView.text else { return nil }
        if text == "" || text == placeholderText{
            return nil
        } else {
            return text
        }
    }
    
    private func setTextViewPlaceholder() {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    private func optionalTextViewPlaceholder() {
        if textView.text != placeholderText {
            textView.textColor = UIColor.black
        } else if textView.text == placeholderText {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
}


extension TextViewTableViewCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        optionalTextViewPlaceholder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        optionalTextViewPlaceholder()
        delegate?.textViewDidChangeSize()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let type = type else { return }
        delegate?.textViewDidEnd(type, self)
        setTextViewPlaceholder()
    }

}

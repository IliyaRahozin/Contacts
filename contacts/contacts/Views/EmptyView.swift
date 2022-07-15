//
//  EmptyView.swift
//  contacts
//
//  Created by Iliya Rahozin on 29.04.2022.
//

import UIKit

class EmptyView: UIView {
    
    // MARK: - Properties
    let imageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Empty State")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Your contact list is empty"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
   lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Contact", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup's
    func config() {
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(addButton)
    }
    
    func setupConstraints() {
        layoutImage()
        layoutTextLabel()
        layoutAddButton()
    }
    
    // MARK: - Layout(Constraints)
    func layoutImage() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -10),
            imageView.topAnchor.constraint(equalTo: self.centerYAnchor, constant: -185)
        ])
        imageView.contentMode = .scaleAspectFill

    }
    
    func layoutTextLabel() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 22),
            textLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            textLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    func layoutAddButton() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor,constant: 10),
            addButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            addButton.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    // MARK: - Methods
    
}

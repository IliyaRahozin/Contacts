//
//  HeaderView.swift
//  contacts
//
//  Created by Iliya Rahozin on 02.06.2022.
//

import UIKit

enum HeaderStyle {
    case add
    case detail
}

protocol HeaderViewDelegate: AnyObject {
    func imgBtnPressed ()
    func didChangeImage()
}

class HeaderView: UIView {
    
    private enum imageViewSize: CGFloat {
        case common = 106
        case small = 46
    }
    
    private var imageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "person.crop.circle.fill")
        if #available(iOS 13.0, *) {
            img.tintColor = .systemGray2
        } else {
            img.tintColor = UIColor(red: 0.60, green: 0.60, blue: 0.64, alpha: 1.00)
        }
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Photo", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var fullNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = nil
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 18.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var widthImgConst: NSLayoutConstraint?
    var heightImgConst: NSLayoutConstraint?
    var topImgConst: NSLayoutConstraint?
    var cornerRadius: CGFloat?
    let defaultImg = UIImage(named: "person.crop.circle.fill")
    
    weak var delegate: HeaderViewDelegate?
        
    // MARK: - Lifecycle
    init(style: HeaderStyle = .add) {
        super.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.minY, width: UIScreen.main.bounds.width, height: 188)) //y: -150
        config(style: style)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup's
    private func config(style: HeaderStyle = .add) {
        switch style {
        case .add:
            if #available(iOS 13.0, *) {
                self.backgroundColor = .groupTableViewBackground
            } else {
                self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
            }
            setupViews()
            setupConstraints()
        case .detail:
            self.backgroundColor = .white
            setupEditViews()
            setupEditConstraints()
        }
    }
    
    private func setupViews(){
        addSubview(imageView)
        addSubview(addButton)
    }
    
    private func setupEditViews() {
        addSubview(imageView)
        addSubview(fullNameLabel)
    }
    
    private func setupConstraints() {
        layoutImage()
        layoutAddButton()
        setRounded()
    }
    
    private func setupEditConstraints() {
        layoutImage()
        layoutFullNameLabel()
        setRounded()
    }
    
    private func setRounded() {
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius =  imageView.frame.width / 2
    }
    
    // MARK: - Layout(Constraints)
    
    private func layoutImage(_ size: imageViewSize = .common) {
        switch size {
        case .common:
            widthImgConst =  imageView.widthAnchor.constraint(equalToConstant: imageViewSize.common.rawValue)
            heightImgConst = imageView.heightAnchor.constraint(equalToConstant: imageViewSize.common.rawValue)
            topImgConst = imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 30)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                topImgConst!,
                widthImgConst!,
                heightImgConst!
            ])
        case .small:
            widthImgConst =  imageView.widthAnchor.constraint(equalToConstant: imageViewSize.small.rawValue)
            heightImgConst = imageView.heightAnchor.constraint(equalToConstant: imageViewSize.small.rawValue)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 24)
            ])
        }
    }
    
    private func layoutAddButton() {
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 10),
            addButton.leftAnchor.constraint(equalTo: self.leftAnchor),
            addButton.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    private func layoutFullNameLabel() {
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 20),
            fullNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            fullNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    
    // MARK: - Action Methods
    @objc private func buttonAction(sender: UIButton!) {
        delegate?.imgBtnPressed()
    }
    
    func setImage(image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            if image != nil {
                self.imageView.image = image
            } else {
                self.imageView.image = self.defaultImg
            }
            self.setRounded()
            self.delegate?.didChangeImage()
        }
    }
    
    func getImage() -> UIImage? {
        return imageView.image
    }
    
    func isImageDefault() -> Bool {
        return getImage() == defaultImg ? true : false
    }
    
    func setBtnLabel(label: String) {
        addButton.setTitle(label, for: .normal)
    }

    
    // Button Alpha
    func decrementAddBtnAlpha(offset: CGFloat) {
        let alphaOffset = 1 - (offset / 60)
        self.addButton.alpha = alphaOffset
    }
    
    // Image Scaling
    func decrementImgSize(offset: CGFloat? = nil) {
        var imgScale: CGFloat = 56
        var topPadding: CGFloat = 20
        if let offset = offset {
            imgScale = 106 - (offset * 0.6)
            topPadding = 30 + (offset * 0.9)
        }
        topImgConst?.constant = topPadding
        widthImgConst?.constant = imgScale
        heightImgConst?.constant = imgScale
        imageView.layer.cornerRadius =  imgScale / 2
    }
    
}



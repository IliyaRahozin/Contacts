//
//  DetailContactVC.swift
//  contacts
//
//  Created by Iliya Rahozin on 13.06.2022.
//

import UIKit

protocol DetailContactDelegate: AnyObject {
    func modalViewWillClose()
}

class DetailContactVC: UITableViewController {
    
    let tableContent: [[CellType]] = [[.firstName,.lastName, .phoneNumber, .email, .birthday, .height],
                                      [.drivingLicenseInfo], [.notes], [.deleteContact]]
    var headerView: HeaderView?
    weak var existingContact: ContactUser?
    weak var delegate: DetailContactDelegate?
    private let dataManager: ContactModelProtocol
    
    init(with dataManager: ContactModelProtocol) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.dataManager = ContactsModel.shared
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.sectionFooterHeight = 0.0
    }
    
    private func configView(){
        setCells()
        setHeaderView()
        setDetailNavBar()
    }
    
    private func setHeaderView() {
        headerView = HeaderView(style: .detail)
        headerView?.delegate = self
        headerView?.setImage(image: existingContact?.loadImage())
        headerView?.fullNameLabel.text = existingContact?.fullName != nil ? existingContact?.fullName : (existingContact?.phoneNumber ?? existingContact?.email)
        self.tableView.addSubview(headerView!)
    }
    
    private func updateHeader() {
        headerView?.setImage(image: existingContact?.loadImage() ?? headerView?.defaultImg)
        headerView?.fullNameLabel.text = existingContact?.fullName != nil ? existingContact?.fullName : (existingContact?.phoneNumber ?? existingContact?.email)
    }
    
    private func setCells() {
        tableView.register(DetailTableViewCell.nib(), forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.register(ButtonTableViewCell.nib(), forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.register(DetailTextViewTableViewCell.nib(), forCellReuseIdentifier: DetailTextViewTableViewCell.identifier)
    }
    
    
    //MARK: - Setup NavBar
    private func setDetailNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPressed))
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @objc private func editPressed() {
        if existingContact != nil {
            editContactVC(existingContact)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableContent.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = tableContent[indexPath.section][indexPath.row]
        
        switch type {
            case .firstName:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.setUpperDescriptionLabel(with: type.title)
                cell.setContactInfoLabel(with: existingContact?.firstName)
                return cell
            case .lastName:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.setUpperDescriptionLabel(with: type.title)
                cell.setContactInfoLabel(with: existingContact?.lastName)
                return cell
            case .phoneNumber:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.setUpperDescriptionLabel(with: type.title)
                cell.setContactInfoLabel(with: existingContact?.phoneNumber)
                return cell
            case .email:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.setUpperDescriptionLabel(with: type.title)
                cell.setContactInfoLabel(with: existingContact?.email)
                return cell
            case .birthday:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.setUpperDescriptionLabel(with: type.title)
                cell.setContactInfoLabel(with: existingContact?.birthday)
                return cell
            case .height:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.isLast = true
                cell.setUpperDescriptionLabel(with: type.title)
                cell.setContactInfoLabel(with: existingContact?.height)
                return cell
            case .drivingLicenseSwitch:
                let cell = tableView.dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as! SwitchTableViewCell
                return cell
            case .drivingLicenseInfo:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
                cell.isLast = true
                cell.setUpperDescriptionLabel(with: type.title)
                cell.setContactInfoLabel(with: existingContact?.drivingLicense)
                return cell
            case .notes:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailTextViewTableViewCell.identifier, for: indexPath) as! DetailTextViewTableViewCell
                cell.isLast = true
                cell.setUpperDescriptionLabel(with: type.title)
                cell.setTextViewText(with: existingContact?.notes)
                return cell
            case .deleteContact:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as! ButtonTableViewCell
                cell.delegate = self
                cell.setbuttonTitleLabel(with: "Delete contact")
                return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = tableContent[indexPath.section][indexPath.row]
        
        switch type {
            
        case .firstName:
            return existingContact?.firstName != nil ? 82 : 0
        case .lastName:
            return existingContact?.lastName != nil ? 82 : 0
        case .phoneNumber:
            return existingContact?.phoneNumber != nil ? 82 : 0
        case .email:
            return existingContact?.email != nil ? 82 : 0
        case .birthday:
            return existingContact?.birthday != nil ? 82 : 0
        case .height:
            return existingContact?.height != nil ? 82 : 0
        case .drivingLicenseSwitch:
            return 0
        case .drivingLicenseInfo:
            return existingContact?.drivingLicense != nil ? 82 : 0
        case .notes:
            return existingContact?.notes != nil ? UITableView.automaticDimension : 0
        case .deleteContact:
            return 82
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 188
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let separator = UIView(frame: CGRect(x: 0, y:0, width: self.tableView.frame.width, height: 1))
        separator.backgroundColor = .lightGray
        
        if section == 0 {
            return nil
        } else if section == 1 {
            return existingContact?.drivingLicense != nil ? separator : nil
        } else if section == 2 {
            return existingContact?.notes != nil ? separator : nil
        } else if section == 3 {
            return separator
        } else {
            return nil
        }
    }
    

}


extension DetailContactVC: AddContactDelegate {
    private func editContactVC(_ contactUser: ContactUser? = nil) {
        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "AddContact") as! AddContactVC
        rootVC.delegate = self
        rootVC.existingContact = contactUser
        let navVC = UINavigationController(rootViewController: rootVC)
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    func modalViewWillClose() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateHeader()
        }
    }
}



extension DetailContactVC: ButtonCellDelegate {
    func buttonDidTapped() {
        print("Contact Deleted")
        deleteAction()
    }
    
    func deleteAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (handler) in
            self.requestDeleteAction()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (handler) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func requestDeleteAction() {
        let alert = UIAlertController(title: "Are you sure, you want to delete this contact?", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (handler) in
            guard let user = self.existingContact else { return }
            self.dataManager.deleteContact(user)
            self.navigationController?.popViewController(animated: true)
            self.delegate?.modalViewWillClose()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (handler) in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension DetailContactVC: HeaderViewDelegate {
    func imgBtnPressed() {
        
    }
    
    func didChangeImage() {
        self.tableView.reloadData()
    }
    
    
}

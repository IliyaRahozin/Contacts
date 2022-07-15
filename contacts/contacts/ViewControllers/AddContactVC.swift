//
//  AddContactVC.swift
//  contacts
//
//  Created by Iliya Rahozin on 01.06.2022.
//

import UIKit
import PhotosUI
import MobileCoreServices
import AVFoundation

enum ContactState {
  case newContact
  case existingContact
}

enum CellType {
    
    // First Section
    case firstName
    case lastName
    case phoneNumber
    case email
    case birthday
    case height
    
    // Second Section
    case drivingLicenseSwitch
    case drivingLicenseInfo
    
    // Third Section
    case notes
    
    // Fourth Section
    case deleteContact
    
    var title: String {
        switch self {
        case .firstName: return "First Name"
        case .lastName: return "Last Name"
        case .phoneNumber: return "Phone number"
        case .email: return "Email"
        case .birthday: return "Birthday"
        case .height: return "Height, cm"
        case .drivingLicenseSwitch: return "Driving license"
        case .drivingLicenseInfo: return "Driving license"
        case .notes: return "Notes"
        case .deleteContact: return "Delete Contact"
        }
    }
}

private enum CustomCells {
    
    case textField
    case switcher
    case textView
    case button
    
    var nib: UINib {
        switch self {
            case .textField:
                return TextFieldTableViewCell.nib()
            case .switcher:
                return SwitchTableViewCell.nib()
            case .textView:
                return TextViewTableViewCell.nib()
            case .button:
                return ButtonTableViewCell.nib()
        }
    }

    var reuseIdentifier: String {
        switch self {
        case .textField:
            return "TextFieldTableViewCell"
        case .switcher:
            return "SwitchTableViewCell"
        case .textView:
            return "TextViewTableViewCell"
        case .button:
            return "ButtonTableViewCell"
        }
    }
}

protocol AddContactDelegate: AnyObject {
    func modalViewWillClose()
}


class AddContactVC: UITableViewController {
    //MARK: - Property
    let tableContent: [[CellType]] = [[.firstName,.lastName, .phoneNumber, .email, .birthday, .height],
                                      [.drivingLicenseSwitch, .drivingLicenseInfo], [.notes], [.deleteContact]]
    var newContact = ContactUser()
    weak var existingContact: ContactUser?
    var contactState = ContactState.newContact
    
    var headerView: HeaderView?
    var switchState: Bool = false
    
    weak var delegate: AddContactDelegate?
    private let dataManager: ContactModelProtocol
    
    init(with dataManager: ContactModelProtocol) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.dataManager = ContactsModel.shared
        super.init(coder: coder)
    }
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private func setState() {
        contactState = existingContact == nil ? .newContact : .existingContact
        if contactState == .existingContact {
            newContact = existingContact?.copy() as! ContactUser
            print(newContact.description)
        }
    }
    
    private func configView(){
        setState()
        setCells()
        setNewContactNavBar()
        setUpHeader()
        configTapGesture()
    }
    
    func setUpHeader() {
        headerView = HeaderView()
        headerView?.delegate = self
        if contactState == .existingContact {
            headerView?.setImage(image: newContact.loadImage())
        }
        self.tableView.addSubview(headerView!)
    }
    
    private func setCells() {
        tableView.register(CustomCells.textField.nib, forCellReuseIdentifier: CustomCells.textField.reuseIdentifier)
        tableView.register(CustomCells.switcher.nib, forCellReuseIdentifier: CustomCells.switcher.reuseIdentifier)
        tableView.register(CustomCells.textView.nib, forCellReuseIdentifier: CustomCells.textView.reuseIdentifier)
        tableView.register(CustomCells.button.nib, forCellReuseIdentifier: CustomCells.button.reuseIdentifier)
    }
    
    //MARK: - Setup NavBar
    func setNewContactNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.title = newContact.fullName != nil ? newContact.fullName : "New Contact"
    }
    
    @objc private func cancelPressed() {
        print("dismiss VC")
        //self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        self.delegate?.modalViewWillClose()
    }
    
    @objc private func savePressed() {
        validateTextFields()
    }

}


// MARK: - TableView dataSource/Delegate
extension AddContactVC {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.textField.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.type = .firstName
            cell.setInputTextField(text: newContact.firstName)
            cell.setLeftTextLabel(with: CellType.firstName.title)
            cell.settextFieldPlaceholder(with: CellType.firstName.title)
            return cell
        case .lastName:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.textField.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.type = .lastName
            cell.setInputTextField(text: newContact.lastName)
            cell.setLeftTextLabel(with: CellType.lastName.title)
            cell.settextFieldPlaceholder(with: CellType.lastName.title)
            return cell
        case .phoneNumber:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.textField.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.type = .phoneNumber
            cell.setInputTextField(text: newContact.phoneNumber)
            cell.setLeftTextLabel(with: CellType.phoneNumber.title)
            cell.settextFieldPlaceholder(with: CellType.phoneNumber.title)
            return cell
        case .email:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.textField.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.type = .email
            cell.setInputTextField(text: newContact.email)
            cell.setLeftTextLabel(with: CellType.email.title)
            cell.settextFieldPlaceholder(with: CellType.email.title)
            return cell
        case .birthday:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.textField.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.type = .birthday
            cell.setInputTextField(text: newContact.birthday)
            cell.setLeftTextLabel(with: CellType.birthday.title)
            cell.settextFieldPlaceholder(with: CellType.birthday.title)
            return cell
        case .height:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.textField.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.isLast = true
            cell.type = .height
            cell.setInputTextField(text: newContact.height)
            cell.setLeftTextLabel(with: CellType.height.title)
            cell.settextFieldPlaceholder(with: CellType.height.title)
            return cell
        case .drivingLicenseSwitch:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.switcher.reuseIdentifier, for: indexPath) as! SwitchTableViewCell
            cell.delegate = self
            if newContact.drivingLicense != nil {
                switchState = true
                cell.switchTurnOn()
            } else {
                cell.switchTurnOn(state: false)
            }
            cell.type = .drivingLicenseSwitch
            cell.setLeftTextLabel(with: CellType.drivingLicenseSwitch.title)
            return cell
        case .drivingLicenseInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.textField.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
            cell.delegate = self
            cell.isLast = true
            cell.setInputTextField(text: newContact.drivingLicense)
            cell.type = .drivingLicenseInfo
            cell.setLeftTextLabel(with: CellType.drivingLicenseInfo.title)
            cell.settextFieldPlaceholder(with: CellType.drivingLicenseInfo.title)
            return cell
        case .notes:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.textView.reuseIdentifier, for: indexPath) as! TextViewTableViewCell
            cell.delegate = self
            if let text = newContact.notes { cell.setTextViewText(text: text) }
            cell.type = .notes
            cell.setLeftTextLabel(with: CellType.notes.title)
            return cell
        case .deleteContact:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomCells.button.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
            cell.delegate = self
            if  contactState == .existingContact { cell.setButtonEnable() }
            cell.type = .deleteContact
            cell.setbuttonTitleLabel(with: CellType.deleteContact.title)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = tableContent[indexPath.section][indexPath.row]
        switch type {
        case .drivingLicenseInfo:
            return switchState ? 44 : 0
        case .notes :
            return UITableView.automaticDimension
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 188
        } else {
            return 44
        }
    }
    
}

// MARK: - Outer Tap
extension AddContactVC {
    
    private func configTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(){
        view.endEditing(true)
    }
    
}

// MARK: - Header Scroll
extension AddContactVC {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
    
        // Scale
        let statusBarPadding: CGFloat?
        let navBarPadding: CGFloat?
        let percentage: CGFloat?

        if #available(iOS 13.0, *) {
            navBarPadding = self.navigationController?.navigationBar.frame.size.height
            guard let navBar = navBarPadding else { return }
            percentage = (offset + navBar)
        } else {
            statusBarPadding = UIApplication.shared.statusBarFrame.height
            navBarPadding = self.navigationController?.navigationBar.frame.size.height
            guard let navBar = navBarPadding, let statusBar = statusBarPadding else { return }
            percentage = (offset + navBar + statusBar)
        }
        guard let percentage = percentage else {return }
        
        // Scroll
        if(offset > 30){
            headerView?.decrementImgSize()
            headerView?.decrementAddBtnAlpha(offset: percentage)
            headerView?.addButton.isHidden = true
            headerView?.frame = CGRect(x: 0, y: percentage, width: self.view.bounds.size.width, height: 96)
        } else{
            headerView?.decrementImgSize(offset: percentage)
            headerView?.decrementAddBtnAlpha(offset: percentage)
            headerView?.addButton.isHidden = false
            headerView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 188)
        }
    }

}


//MARK: - SwitchCell Delegate
extension AddContactVC: SwitchCellDelegate {
    func switchDidChanges(_ cell: SwitchTableViewCell, state: Bool) {
        let indexPath: IndexPath = [1,1]
        self.switchState = state
        if !state {
            guard let cell = tableView.cellForRow(at: indexPath) as? TextFieldTableViewCell else { return }
            cell.resetTextField()
            newContact.drivingLicense = cell.getTextFiledText()
        }
        tableView.beginUpdates()
        tableView.endUpdates()

    }
}


//MARK: - TextFieldCell Delegate
extension AddContactVC: TextFieldCellDelegate {
    func didChangeText(_ type: CellType?, _ cell: TextFieldTableViewCell) {
        
        switch type {
        case .firstName:
            newContact.firstName = cell.getTextFiledText()
        case .lastName:
            newContact.lastName = cell.getTextFiledText()
        case .phoneNumber:
            newContact.phoneNumber = cell.getTextFiledText()
        case .email:
            newContact.email = cell.getTextFiledText()
        case .birthday:
            newContact.birthday = cell.getTextFiledText()
        case .height:
            newContact.height = cell.getTextFiledText()
        case .drivingLicenseInfo:
            if switchState { newContact.drivingLicense = cell.getTextFiledText() }
        default: break
        }
    }

    
    func checkOptionalTextFields(_ cell: TextFieldTableViewCell) {
        if (newContact.firstName != nil  || newContact.lastName != nil || newContact.phoneNumber != nil || newContact.email != nil) {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    // Call delegate func to start validating textFields
    private func validateTextFields() {
        var errors: Int = 0
        for (section, arr) in tableContent.enumerated() {
            for (row, element) in arr.enumerated() {
                let index = IndexPath(row: row, section: section)
                switch element {
                case .firstName, .lastName, .email, .phoneNumber :
                    let cell = tableView.cellForRow(at: index) as! TextFieldTableViewCell
                    if cell.validateTextField() != nil {
                        errors += 1
                    }
                default :
                    print("skip")
                }
                
            }
        }
        if errors == 0 {
            saveContact()
        }
        print(newContact.description)
        
    }
    
    
    private func saveContact() {
        switch contactState {
            case .newContact:
                print("savePressed")
                dismiss(animated: true) {
                    print(self.newContact.description)
                    self.dataManager.addNewContactUser(self.newContact)
                    self.delegate?.modalViewWillClose()
                }
            case .existingContact:
                print("savePressed - Contact Info Updated")
                dismiss(animated: true) {
                    guard let oldContact = self.existingContact else { return }
                    self.dataManager.updateInfo(oldContact, self.newContact)
                    self.delegate?.modalViewWillClose()
                }
        }
    }
    
}


//MARK: - TextViewCell Delegate
extension AddContactVC: TextViewCellDelegate {
    func textViewDidChangeSize() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func textViewDidEnd(_ type: CellType, _ cell: TextViewTableViewCell) {
        switch type {
        case .notes:
            self.newContact.notes = cell.getTextViewText()
        default: break
        }
    }
}

//MARK: - ButtonCell Delegate
extension AddContactVC: ButtonCellDelegate {
    func buttonDidTapped() {
        switch contactState {
            case .newContact:
                print("Contact Canceled")
                dismiss(animated: true) {
                    self.delegate?.modalViewWillClose()
                }
            case .existingContact:
                print("Contact Deleted")
                dismiss(animated: true) { }
        }
    }
    
    
}


//MARK: - Add Photo
extension AddContactVC: HeaderViewDelegate {
    
    func imgBtnPressed() {
        self.imageAction()
    }
    

    func didChangeImage() {
        if ((headerView?.isImageDefault()) == false) {
            headerView?.setBtnLabel(label: "Change photo")
        } else {
            headerView?.setBtnLabel(label: "Add photo")
        }
    }
    
    
    func imageAction() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        #if targetEnvironment(simulator)
        #else
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {(handler) in
            self.checkCameraPersmission()
        }))
        #endif
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: {(handler) in
            self.checkGalleryPersmission()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (handler) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.sourceType = .camera
            image.mediaTypes = [kUTTypeImage as String]
            self.present(image, animated: true, completion: nil)
        }
    }
    
    
    private func openGallery() {
        DispatchQueue.main.async {
            if #available(iOS 14, *) {
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                configuration.selectionLimit = 1
                configuration.preferredAssetRepresentationMode = .automatic

                let picker = PHPickerViewController(configuration: configuration)
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                //present(picker, animated: true)
            } else {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let image = UIImagePickerController()
                    image.allowsEditing = true
                    image.delegate = self
                    image.sourceType = .photoLibrary
                    image.mediaTypes = [kUTTypeImage as String]
                    self.present(image, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func presentGallerySettings() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            let alertController = UIAlertController(title: "Photo Access", message: "Access to the gallery as been prohibited, please enanble in the Settings app to contunie", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default)
            let settings = UIAlertAction(title: "Settings", style: .default , handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            alertController.addAction(cancel)
            alertController.addAction(settings)
            alertController.preferredAction = settings
            self.present(alertController,animated: true)
        }
    }
    
    private func presentCameraSettings() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            let alertController = UIAlertController(title: "Camera Access", message: "Access to the camera has been prohibited, please enanble in the Settings app to contunie", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default)
            let settings = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            alertController.addAction(cancel)
            alertController.addAction(settings)
            alertController.preferredAction = settings
            self.present(alertController,animated: true)
        }
    }
    
    
    @objc private func checkCameraPersmission() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { (success) in
                    if success {
                        print("Permission granted")
                    } else {
                        print("Permission not granted")
                    }
                }
                break
            case .restricted:
                print("User Don't allow")
                break
            case .denied:
                print("Denied status called")
                self.presentCameraSettings()
                break
            case .authorized:
                print("Success camera status")
                self.openCamera()
                break
            @unknown default:
                print("Error")
                break
            }
    }
    
    @objc private func checkGalleryPersmission() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
            case .notDetermined:
                DispatchQueue.main.async {
                    PHPhotoLibrary.requestAuthorization { status in
                            switch status {
                                case .authorized:
                                    self.openGallery()
                                    break
                                case .denied, .restricted:
                                    self.presentGallerySettings()
                                    break
                                case .notDetermined:
                                    break
                                case .limited:
                                    if #available(iOS 14, *) {
                                        let controller = self
                                        PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: controller)
                                    }
                                    break
                                @unknown default:
                                    print("Error handling gallery permission")
                                    break
                                }
                            }
                }
                break
            case .restricted:
                print("User Don't allow")
                break
            case .denied:
                print("Denied status called")
                self.presentGallerySettings()
                break
            case .authorized:
                print("Success gallery status")
                self.openGallery()
                break
            case .limited:
                print("Limited")
                if #available(iOS 14, *) {
                    let controller = self
                    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: controller)
                }
                break
        @unknown default:
                print("Error")
                break
            }
        
    }
    
}
// MARK: - Gallery - UIImagePickerController
extension AddContactVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        if let header = self.headerView {
                            self.newContact.saveImage(image: image)
                            header.setImage(image: self.newContact.loadImage())
                            self.tableView.beginUpdates()
                            self.tableView.endUpdates()
                        } else { }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Gallery - PHPickerViewController
@available(iOS 14, *)
extension AddContactVC: PHPickerViewControllerDelegate, PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
    }
    
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard !results.isEmpty else { return }
        
        let result = results.first!
        let itemProvider = result.itemProvider
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error  in
                DispatchQueue.main.async { [weak self] in
                    if let image = image as? UIImage {
                        if let header = self?.headerView {
                            self?.newContact.saveImage(image: image)
                            header.setImage(image: self?.newContact.loadImage())
                            self?.tableView.beginUpdates()
                            self?.tableView.endUpdates()
                        }
                    }else { }
                }
            }
        }
        dismiss(animated: true) {}
        
    }
   
    
}

//MARK: - Alert Constaint
// Fixing Alert Constarint Width
extension UIAlertController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        pruneNegativeWidthConstraints()
    }

    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

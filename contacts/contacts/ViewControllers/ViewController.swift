//
//  ViewController.swift
//  contacts
//
//  Created by Iliya Rahozin on 20.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private let dataManager: ContactModelProtocol
    
    init(with dataManager: ContactModelProtocol) {
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.dataManager = ContactsModel.shared
        super.init(coder: coder)
    }
    
    lazy var settingsBtn = UIBarButtonItem(
        image: UIImage(named: "gearshape"),
        style: .plain,
        target: self,
        action: #selector(settingsPressed)
    )
    lazy var addBtn = UIBarButtonItem(
        image: UIImage(named:"plus"),
        style: .plain,
        target: self,
        action: #selector(addBtnPressed)
    )
    
    lazy var editBtn = UIBarButtonItem(
        barButtonSystemItem: .edit,
        target: self,
        action: #selector(editBtnPressed)
    )

    
    var bottomAddBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Contact", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00)
        btn.layer.shadowColor = UIColor(red: 0.90, green: 0.90, blue: 0.91, alpha: 1.00).cgColor
        btn.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        btn.layer.shadowOpacity = 2.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(addBtnPressed), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.frame = view.bounds
        tableView.register(ContactTableViewCell.nib(), forCellReuseIdentifier: ContactTableViewCell.identifier)
    }
    
    // MARK: - Methods
    func checkIsEmpty() {
        if dataManager.contacts.isEmpty {
            lazy var tableEmptyView = EmptyView(frame: view.safeAreaLayoutGuide.layoutFrame)
            tableEmptyView.addButton.addTarget(self, action: #selector(addBtnPressed), for: .touchUpInside)
            hideNavBarButtons()
            hideBottomAddButton()
            tableView.backgroundView = tableEmptyView

        } else {
            showNavBarButtons()
            showBottomAddButton()
            tableView.backgroundView = .none
        }
    }
    
    @objc func addBtnPressed() {
        print("Add Contact - pressed")
        showContactVC()
    }
    
    @objc func settingsPressed() {
        print("Settings - pressed")
    }
    
    @objc func editBtnPressed() {
        print("Edit - pressed")
    }
    
}


// MARK: - Table Settings (rows, cell)
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkIsEmpty()
        return dataManager.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        cell.setContact(dataManager.contacts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactUser = dataManager.contacts[indexPath.row]
        showDetailVC(contactUser)
    }
}

// Present Add/Edit VC
extension ViewController {
    private func showContactVC(_ contactUser: ContactUser? = nil) {
        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "AddContact") as! AddContactVC
        rootVC.delegate = self
        rootVC.existingContact = contactUser
        let navVC = UINavigationController(rootViewController: rootVC)
        self.navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    private func showDetailVC(_ contactUser: ContactUser? = nil) {
        let rootVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailContact") as! DetailContactVC
        rootVC.delegate = self
        rootVC.existingContact = contactUser
        self.navigationController?.pushViewController(rootVC, animated: true)
    }
}

extension ViewController {
    func hideNavBarButtons() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    func showNavBarButtons() {
        self.navigationItem.leftBarButtonItem = settingsBtn
        self.navigationItem.rightBarButtonItem = editBtn
    }
    
    func showBottomAddButton() {
        view.addSubview(bottomAddBtn)
        setBottomBtnConst()
    }
    
    func hideBottomAddButton() {
        self.view.subviews.forEach ({
            if $0 is UIButton {
                $0.removeFromSuperview()
            }
        })
    }
    
    private func setBottomBtnConst() {
        NSLayoutConstraint.activate([
            bottomAddBtn.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            bottomAddBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bottomAddBtn.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20),
            bottomAddBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension ViewController: AddContactDelegate, DetailContactDelegate {
    func modalViewWillClose() {
        tableView.reloadData()
    }

}

extension ViewController: UINavigationControllerDelegate {
    override func didMove(toParent parent: UIViewController?) {
        tableView.reloadData()
    }

}

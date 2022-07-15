//
//  ContactsModel.swift
//  contacts
//
//  Created by Iliya Rahozin on 08.06.2022.
//

import UIKit
import Foundation

protocol ContactModelProtocol {
    var contacts: [ContactUser] { get set }
    func setupTestUsers()
    func addNewContactUser(_ newContactUser: ContactUser)
    func updateInfo(_ oldContcact: ContactUser, _ with: ContactUser )
    func deleteContact(_ contact: ContactUser)
}


final class ContactsModel: ContactModelProtocol {
    let defaults = UserDefaults.standard
    static let shared: ContactModelProtocol = ContactsModel()
    
    var contacts = [ContactUser]()
//    var contacts: [ContactUser] {
//        get {
//            if let data = defaults.value(forKey: "contacts") as? Data {
//                //return try! PropertyListDecoder().decode([ContactUser].self, from: data)
//            } else {
//                return [ContactUser]()
//            }
//        }
//        set {
////            if let data = try? PropertyListEncoder().encode(newValue){
////                defaults.set(data, forKey: "contacts")
////            }
//        }
//    }
    
    private init() {
        setupTestUsers()
    }
    
    func addNewContactUser(_ newContactUser: ContactUser) {
        contacts.append(newContactUser)
    }
    
    func updateInfo(_ oldContcact: ContactUser, _ newContact: ContactUser) {
        oldContcact.updateValues(newUserData: newContact)
    }
    
    func deleteContact(_ contact: ContactUser) {
        if let idx = contacts.firstIndex(where: { $0 === contact }) {
            contacts.remove(at: idx)
        }
    }
    
    
    func setupTestUsers() {
        let user1 = ContactUser(userImage: nil, firstName: "user1", lastName: nil, phoneNumber: "123-123-123", email: nil, birthday: nil, height: nil, drivingLicense: nil, notes: nil)
        let user2 = ContactUser(userImage: nil, firstName: "user2", lastName: nil, phoneNumber: "123-123-123", email: nil, birthday: nil, height: nil, drivingLicense: nil, notes: nil)
        addNewContactUser(user1)
        addNewContactUser(user2)
    }
    
    
}


extension Array where Element: Equatable {
    @discardableResult
    public mutating func replace(_ element: Element, with new: Element) -> Bool {
        if let f = self.firstIndex(where: { $0 == element}) {
            self[f] = new
            return true
        }
        return false
    }
    
    @discardableResult
    mutating func remove(_ element : Element) -> Element?
    {
        if let index = firstIndex(of: element) {
            return remove(at: index)
        }
        return nil
    }
}

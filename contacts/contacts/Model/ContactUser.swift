//
//  ContactUser.swift
//  contacts
//
//  Created by Iliya Rahozin on 08.06.2022.
//

import UIKit
import Foundation

protocol ContactProtocol {
    var id: UUID { get set }
    var imageData: String? { get set }
    var firstName: String? { get set }
    var lastName: String? { get set }
    var phoneNumber: String? { get set }
    var email: String? { get set }
    var birthday: String? { get set }
    var height: String? { get set }
    var drivingLicense: String? { get set }
    var notes: String? { get set }
    
    func reset()
}


class ContactUser: ContactProtocol, NSCopying {
    var id: UUID

    var imageData: String?
    
    var firstName: String?
    
    var lastName: String?
    
    var phoneNumber: String?
    
    var email: String?
    
    var birthday: String?
    
    var height: String?
    
    var drivingLicense: String?
    
    var notes: String?
    
    init() {
        self.id = UUID()
        self.imageData = nil
        self.firstName = nil
        self.lastName = nil
        self.phoneNumber = nil
        self.birthday = nil
        self.height = nil
        self.drivingLicense = nil
        self.notes = nil
    }
    
    init(userImage: String?, firstName: String?, lastName: String?, phoneNumber: String?, email: String?, birthday: String?, height: String?, drivingLicense: String?, notes: String?) {
        self.id = UUID()
        self.imageData = userImage
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
        self.birthday = birthday
        self.height = height
        self.drivingLicense = drivingLicense
        self.notes = notes
    }
    
    func reset() {
        self.imageData = nil
        self.firstName = nil
        self.lastName = nil
        self.phoneNumber = nil
        self.email = nil
        self.birthday = nil
        self.height = nil
        self.drivingLicense = nil
        self.notes = nil
    }
    
    var description : String {
        return  "Image: \(imageData?.description ?? "empty")\n" +
                "First Name: \(firstName ?? "empty")\n" +
                "Last Name: \(lastName ?? "empty")\n" +
                "Phone number: \(phoneNumber ?? "empty")\n" +
                "Email: \(email ?? "empty")\n" +
                "Birthday: \(birthday ?? "empty")\n" +
                "Height: \(height ?? "empty")\n" +
                "Driving License: \(drivingLicense ?? "empty")\n" +
                "Notes: \(notes ?? "empty")\n"
    }
    
    var fullName: String? {
        if firstName != nil && lastName != nil {
            return "\(firstName!) \(lastName!)"
        } else if firstName != nil  {
            return firstName
        } else if lastName != nil {
            return lastName
        } else {
            return nil
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ContactUser()
        copy.id = self.id
        copy.imageData = self.imageData
        copy.firstName = self.firstName
        copy.lastName = self.lastName
        copy.phoneNumber = self.phoneNumber
        copy.email = self.email
        copy.birthday = self.birthday
        copy.height = self.height
        copy.drivingLicense = self.drivingLicense
        copy.notes = self.notes
        return copy
    }
    
    func updateValues(newUserData: ContactUser) {
        self.imageData = newUserData.imageData
        self.firstName = newUserData.firstName
        self.lastName = newUserData.lastName
        self.phoneNumber = newUserData.phoneNumber
        self.email = newUserData.email
        self.birthday = newUserData.birthday
        self.height = newUserData.height
        self.drivingLicense = newUserData.drivingLicense
        self.notes = newUserData.notes
    }
    
    deinit {
       print("destroyed.")
    }
    
    func saveImage(image: UIImage) {
        autoreleasepool{
            if let data = image.jpegData(compressionQuality: 0.5) {
                    print(self.id.description)
                    let filename = self.getDocumentsDirectory().appendingPathComponent("\(self.id.uuidString).jpeg")
                    try? data.write(to: filename)
            }
        }
    }
    
    func loadImage() -> UIImage {
        // autoreleasepool {
            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
                let imageUrl = URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("\(self.id.uuidString).jpeg")
                if let image = UIImage(contentsOfFile: imageUrl.path) {
                    return image
                }
            }
            return UIImage(named: "person.crop.circle.fill")!

//        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
//    func encode(with coder: NSCoder) {
//        coder.encode(imageData, forKey: "imageData")
//        coder.encode(firstName, forKey: "firstName")
//        coder.encode(lastName, forKey: "lastName")
//        coder.encode(phoneNumber, forKey: "phoneNumber")
//        coder.encode(email, forKey: "email")
//        coder.encode(birthday, forKey: "birthday")
//        coder.encode(height, forKey: "height")
//        coder.encode(drivingLicense, forKey: "drivingLicense")
//        coder.encode(notes, forKey: "notes")
//    }
//
//    required init?(coder: NSCoder) {
//        self.imageData = coder.decodeObject(forKey: "imageData") as? UIImage ?? nil
//        self.firstName = coder.decodeObject(forKey: "firstName") as? String ?? nil
//        self.lastName = coder.decodeObject(forKey: "lastName") as? String ?? nil
//        self.phoneNumber = coder.decodeObject(forKey: "phoneNumber") as? String ?? nil
//        self.email = coder.decodeObject(forKey: "email") as? String ?? nil
//        self.birthday = coder.decodeObject(forKey: "birthday") as? String ?? nil
//        self.height = coder.decodeObject(forKey: "height") as? String ?? nil
//        self.drivingLicense = coder.decodeObject(forKey: "drivingLicense") as? String ?? nil
//        self.notes = coder.decodeObject(forKey: "notes") as? String ?? nil
//    }
}

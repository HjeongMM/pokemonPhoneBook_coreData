//
//  PhoneBook+CoreDataClass.swift
//  pokemon_PhoneBook_coreData
//
//  Created by 임혜정 on 7/17/24.
//
//

import Foundation
import CoreData

@objc(PhoneBook)
public class PhoneBook: NSManagedObject {
    public static let className = "PhoneBook"
    public enum Key {
        static let name = "name"
        static let phoneNumber = "phoneNumber"
        static let imageURL = "imageURL"
    }
}

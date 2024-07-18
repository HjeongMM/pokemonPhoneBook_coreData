//
//  PhoneBook+CoreDataProperties.swift
//  pokemon_PhoneBook_coreData
//
//  Created by 임혜정 on 7/17/24.
//
//

import Foundation
import CoreData


extension PhoneBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneBook> {
        return NSFetchRequest<PhoneBook>(entityName: "PhoneBook")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var imageURL: String?

}

extension PhoneBook : Identifiable {

}



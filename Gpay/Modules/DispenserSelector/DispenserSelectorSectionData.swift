//
//  DispenserSelectorSection.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 19/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import RxDataSources

enum SectionDataType {
    
    case dispensers(items: [(index: Int, dispenser: Dispenser?)])
    
    case fuel(fuel: Fuel)
    
    case title(text: String)
}

struct DispenserSelectorSectionData {
    
    private var id = UUID().uuidString
    
    var type: SectionDataType
    
    
    init(type: SectionDataType) {
        
        self.type = type
    }
}

extension DispenserSelectorSectionData: IdentifiableType {
    
    typealias Identity = String
    
    var identity: String {
        
        return id
    }
}

extension DispenserSelectorSectionData: Equatable {
    
    static func ==(lhs: DispenserSelectorSectionData, rhs: DispenserSelectorSectionData) -> Bool {
        
        return lhs.id == rhs.id
    }
}

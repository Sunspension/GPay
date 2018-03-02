//
//  ResponseError.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 26/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation

struct ResponseError: Decodable {
    
    let errorCode: String
    let errorMessage: String
}

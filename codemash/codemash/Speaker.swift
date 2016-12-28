//
//  Speaker.swift
//  codemash
//
//  Created by Brandon Campbell on 12/5/16.
//  Copyright © 2016 Brandon Campbell. All rights reserved.
//

import Foundation

struct Speaker {
    var firstName: String
    var lastName: String
    var speakerId: String
    var gravatarUrl: String
}

extension Speaker {
    static func parse(fromDictionary: Dictionary<String, Any>) -> Speaker {
        return Speaker.init(firstName: fromDictionary["FirstName"] as! String,
                            lastName: fromDictionary["LastName"] as! String,
                            speakerId: fromDictionary["Id"] as! String,
                            gravatarUrl: fromDictionary["GravatarUrl"] as! String)
    }
}

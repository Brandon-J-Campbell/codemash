//
//  XMLHelper.swift
//  codemash
//
//  Created by Brandon Campbell on 10/25/16.
//  Copyright © 2016 Brandon Campbell. All rights reserved.
//

import Foundation
import SWXMLHash

extension XMLIndexer {
    
    func text(forElementString: String) -> String {
        if let value = self[forElementString].element?.text {
            return value
        } else {
            return ""
        }
    }
}

//
//  Session.swift
//  codemash
//
//  Created by Brandon Campbell on 10/10/16.
//  Copyright © 2016 Brandon Campbell. All rights reserved.
//

import Foundation
import SWXMLHash

struct Session {
    var abstract : String
    var category : String
    var sessionId : Int
    var rooms : Array<String>
    var endTime : Date
    var startTime : Date
    var time : Date
    var sessionType : String
    var speakers : Array<Speaker>
    var tags : Array<String>
    var title : String
}

extension Session {
    static func parse(fromDictionary: Dictionary<String, Any>) -> Session {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        var speakers = Array<Speaker>()
        
        for dict in fromDictionary["Speakers"] as! Array<Dictionary<String, Any>> {
            speakers.append(Speaker.parse(fromDictionary: dict))
        }
        
        return Session.init(abstract: fromDictionary["Abstract"] as! String,
                            category: fromDictionary["Category"] as! String,
                            sessionId: fromDictionary["Id"] as! Int,
                            rooms: fromDictionary["Rooms"] as! Array<String>,
                            endTime: formatter.date(from: fromDictionary["SessionEndTime"] as! String)!,
                            startTime: formatter.date(from: fromDictionary["SessionStartTime"] as! String)!,
                            time: formatter.date(from: fromDictionary["SessionTime"] as! String)!,
                            sessionType: fromDictionary["SessionType"] as! String,
                            speakers: speakers,
                            tags: fromDictionary["Tags"] as! Array<String>,
                            title: fromDictionary["Title"] as! String)
    }
}



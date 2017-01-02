//
//  SessionViewController.swift
//  codemash
//
//  Created by Brandon Campbell on 12/27/16.
//  Copyright © 2016 Brandon Campbell. All rights reserved.
//

import Foundation
import UIKit

class SessionViewController : UIViewController {
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var dateLabel : UILabel?
    @IBOutlet var roomLabel : UILabel?
    @IBOutlet var tagsLabel : UILabel?
    @IBOutlet var descriptionLabel : UILabel?
    @IBOutlet var speakerLabel : UILabel?
    @IBOutlet var imageView : UIImageView?
    
    var session : Session?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let timeFormatter = DateFormatter.init()
        timeFormatter.dateFormat = "h:mm:ssa"
        
        titleLabel?.text = session?.title
        dateLabel?.text = timeFormatter.string(from: (session?.startTime)!)
        roomLabel?.text = arrayToString(array: (session?.rooms)!)
        descriptionLabel?.text = session?.abstract
        tagsLabel?.text = arrayToString(array: (session?.tags)!)
     
        var speakers = ""
        
        for speaker in (session?.speakers)! {
            speakers.append(speaker.firstName + " " + speaker.lastName)
            
            if speaker.speakerId != (session?.speakers)!.last?.speakerId {
                speakers.append(", ")
            }
        }
        
        speakerLabel?.text = speakers
        
        if let url = URL.init(string: "https:" + (session?.speakers[0].gravatarUrl)!) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error)  in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    DispatchQueue.main.async() { () -> Void in
                        self.imageView?.image = UIImage(data: data)
                    }
            }.resume()
        }
    }
    
    func arrayToString(array : Array<String>) -> String {
        var rv = ""
        
        for value in array {
            rv.append(value)
            
            if value != array.last {
                rv.append(", ")
            }
        }
        
        return rv
    }
}

//
//  ContainerViewController.swift
//  codemash
//
//  Created by Brandon Campbell on 12/5/16.
//  Copyright © 2016 Brandon Campbell. All rights reserved.
//

import Foundation
import UIKit

class ContainerRow {
    var tabName : String?
    var items = Array<ContainerRow>()
    
    convenience init(withTabName: String) {
        self.init()
        
        self.tabName = withTabName
    }
    
    convenience init(items: Array<ContainerRow>) {
        self.init()
        
        self.items = items
    }
}

class ContainerCell : UICollectionViewCell {
    var viewController : ScheduleTableViewController?
    
    static func cellIdentifier() -> String {
        return "ContainerCell"
    }
    
    static func cell(forCollectionView collectionView: UICollectionView, indexPath: IndexPath, tabName: String) -> ContainerCell {
        let cell : ContainerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContainerCell.cellIdentifier(), for: indexPath) as! ContainerCell
        return cell
    }
}

class ContainerViewController : UICollectionViewController {
    var data = Dictionary<String, Array<Session>>()
    var sessions : Array<Session> = Array<Session>.init()
    
    var sections = Array<ContainerRow>()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        let urlSession = URLSession.shared
        urlSession.dataTask(with: URL.init(string: "https://speakers.codemash.org/api/SessionsData/")!, completionHandler: { (data, response, error) -> Void in
            if let HTTPResponse = response as? HTTPURLResponse {
                let statusCode = HTTPResponse.statusCode
                if(data == nil || error != nil || statusCode != 200) {
                    print(error.debugDescription)
                } else {
                    do {
                        let convertedString = String(data: data!, encoding: String.Encoding.utf8) // the data will be converted to the string
                        print(convertedString!)
                        
                        let array : Array<Any?> = try JSONSerialization.jsonObject(with: data!, options: [.allowFragments]) as! Array<Any?>
                        for dict : Dictionary<String, Any> in array as! Array<Dictionary<String, Any>> {
                            let session = Session.parse(fromDictionary: dict)
                            self.sessions.append(session)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    DispatchQueue.main.async {
                        self.setupSections()
                    }
                }
            }
        }).resume()
        */
        var rawSessions = Array<Session>.init()
        
        if let url = Bundle.main.url(forResource: "SessionsData", withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let array : Array<Any?> = try JSONSerialization.jsonObject(with: data as Data, options: [.allowFragments]) as! Array<Any?>
                    for dict : Dictionary<String, Any> in array as! Array<Dictionary<String, Any>> {
                        let session = Session.parse(fromDictionary: dict)
                        rawSessions.append(session)
                    }
                } catch {
                    print("Error!! Unable to parse SessionsData.json")
                }
            }
            print("Error!! Unable to load SessionsData.json")
        }
        
        self.sessions = rawSessions.sorted()
        
        self.setupSections()
    }
    
    func setupSections() {
        var sections : Array<ContainerRow> = []
        var rows : Array<ContainerRow> = []
        
        let dayFormatter = DateFormatter.init()
        dayFormatter.dateFormat = "EEEE"
        
        for session in self.sessions {
            let day = dayFormatter.string(from: session.startTime)
            
            if data[day] == nil {
                data[day] = Array<Session>()
                rows.append(ContainerRow.init(withTabName: day))
            }
            data[day]?.append(session)
        }
        
        sections.append(ContainerRow.init(items: rows))
        self.sections = sections
        
        self.collectionView?.reloadData()
    }
}

extension ContainerViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.items.count
    }
}

extension ContainerViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = self.sections[indexPath.section]
        let row = section.items[indexPath.row]
        
        let cell = ContainerCell.cell(forCollectionView: collectionView, indexPath: indexPath, tabName: row.tabName!)
        
        if (cell.viewController == nil) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleTableViewController") as! ScheduleTableViewController
            cell.viewController = vc
            
            self.addChildViewController(vc)
            cell.addSubview((vc.view)!)
            
            vc.view.frame = cell.bounds
            vc.view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        }
        cell.viewController?.sessions = data[row.tabName!]!
        
        return cell
    }
}

extension ContainerViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

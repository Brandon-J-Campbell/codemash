//
//  ScheduleCollectionViewController.swift
//  codemash
//
//  Created by Brandon Campbell on 12/30/16.
//  Copyright © 2016 Brandon Campbell. All rights reserved.
//

import Foundation
import UIKit

class ScheduleeRow {
    var header : String?
    var items = Array<ScheduleeRow>()
    var session : Session?
    
    convenience init(withHeader: String, items: Array<ScheduleeRow>) {
        self.init()
        
        self.header = withHeader
        self.items = items
    }
    
    convenience init(withSession: Session) {
        self.init()
        
        self.session = withSession
    }
}

class ScheduleCollectionCell : UICollectionViewCell {
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var roomLabel: UILabel?
    @IBOutlet var speakerImageView: UIImageView?
    
    var session : Session?
    
    static func cellIdentifier() -> String {
        return "ScheduleCollectionCell"
    }
    
    static func cell(forCollectionView collectionView: UICollectionView, indexPath: IndexPath, session: Session) -> ScheduleCollectionCell {
        let cell : ScheduleCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ScheduleCollectionCell.cellIdentifier(), for: indexPath) as! ScheduleCollectionCell
        
        cell.speakerImageView?.image = nil
        cell.titleLabel?.text = session.title
        cell.roomLabel?.text = session.rooms[0]
        cell.session = session
        
        if let url = URL.init(string: "https:" + (session.speakers[0].gravatarUrl)) {
            URLSession.shared.dataTask(with: url) {
                (data, response, error)  in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { () -> Void in
                    cell.speakerImageView?.image = UIImage(data: data)
                }
                }.resume()
        }
        return cell
    }
}

class ScheduleCollectionHeaderView : UICollectionReusableView {
    @IBOutlet var headerLabel : UILabel?
    
    static func cellIdentifier() -> String {
        return "ScheduleCollectionHeaderView"
    }
}

class ScheduleCollectionViewController : UICollectionViewController {
    var sections = Array<ScheduleTableRow>()
    var sessions : Array<Session> = Array<Session>.init() {
        didSet {
            self.data = Dictionary<Date, Array<Session>>()
            self.setupSections()
        }
    }
    var data = Dictionary<Date, Array<Session>>()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSession" {
            let vc = segue.destination as! SessionViewController
            let cell = sender as! ScheduleCollectionCell
            vc.session = cell.session
        }
    }
    
    func setupSections() {
        let timeFormatter = DateFormatter.init()
        timeFormatter.dateFormat = "EEEE h:mm:ssa"
        
        for session in self.sessions {
            
            if data[session.startTime] == nil {
                data[session.startTime] = Array<Session>()
            }
            data[session.startTime]?.append(session)
        }
        
        var sections : Array<ScheduleTableRow> = []
        for key in data.keys.sorted() {
            var rows : Array<ScheduleTableRow> = []
            
            for session in data[key]! {
                rows.append(ScheduleTableRow.init(withSession: session))
            }
            let time = timeFormatter.string(from: key)
            sections.append(ScheduleTableRow.init(withHeader: time, items: rows))
        }
        self.sections = sections
        
        self.collectionView?.reloadData()
    }
}

extension ScheduleCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.items.count
    }
}

extension ScheduleCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = self.sections[indexPath.section]
        let row = section.items[indexPath.row]
        
        let cell = ScheduleCollectionCell.cell(forCollectionView: collectionView, indexPath: indexPath, session: row.session!)
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderColor = UIColor.black.cgColor
        if (self.view.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClass.compact) {
            cell.contentView.layer.borderWidth = 1.0
        } else {
            cell.contentView.layer.borderWidth = 0.0
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = self.sections[indexPath.section]
        
        let headerView: ScheduleCollectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ScheduleCollectionHeaderView.cellIdentifier(), for: indexPath) as! ScheduleCollectionHeaderView
        headerView.headerLabel?.text = section.header
        return headerView
    }
}

extension ScheduleCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat
        
        if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClass.compact) {
            width = collectionView.bounds.size.width
        } else {
            let flowLayout : UICollectionViewFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            width = (collectionView.bounds.size.width - flowLayout.minimumLineSpacing - flowLayout.minimumInteritemSpacing - flowLayout.sectionInset.left - flowLayout.sectionInset.right) / (collectionView.bounds.size.width > 800.0 ? 3.0 : 2.0)
        }
        return CGSize.init(width: width, height: 100.0)
    }
}

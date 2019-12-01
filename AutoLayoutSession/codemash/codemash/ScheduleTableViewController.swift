//
//  ScheduleViewController.swift
//  codemash
//
//  Created by Brandon Campbell on 12/23/16.
//  Copyright © 2016 Brandon Campbell. All rights reserved.
//

import Foundation
import UIKit

class ScheduleTableRow {
    var header : String?
    var items = Array<ScheduleTableRow>()
    var session : Session?
    
    convenience init(withHeader: String, items: Array<ScheduleTableRow>) {
        self.init()
        
        self.header = withHeader
        self.items = items
    }
    
    convenience init(withSession: Session) {
        self.init()
        
        self.session = withSession
    }
}

class ScheduleTableCell : UITableViewCell {
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var roomLabel: UILabel?
    
    static func cellIdentifier() -> String {
        return "ScheduleTableCell"
    }
    
    static func cell(forTableView tableView: UITableView, indexPath: IndexPath, session: Session) -> ScheduleTableCell {
        let cell : ScheduleTableCell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableCell.cellIdentifier(), for: indexPath) as! ScheduleTableCell
        
        cell.titleLabel?.text = session.title
        cell.roomLabel?.text = session.rooms[0]
        
        return cell
    }
}

class ScheduleTableViewController : UITableViewController {
    var sections = Array<ScheduleTableRow>()
    var sessions : Array<Session>?
    var data = Dictionary<String, Array<Session>>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupSections()
    }
    
    func setupSections() {
        let timeFormatter = DateFormatter.init()
        timeFormatter.dateFormat = "h:mm:ssa"
        
        for session in self.sessions! {
            let time = timeFormatter.string(from: session.startTime) + " - " + timeFormatter.string(from: session.endTime)
            
            if data[time] == nil {
                data[time] = Array<Session>()
            }
            data[time]?.append(session)
        }
        
        var sections : Array<ScheduleTableRow> = []
        for key in data.keys {
            var rows : Array<ScheduleTableRow> = []
            
            for session in data[key]! {
                rows.append(ScheduleTableRow.init(withSession: session))
            }
            sections.append(ScheduleTableRow.init(withHeader: key, items: rows))
        }
        self.sections = sections
        
        self.tableView?.reloadData()
    }
}

extension ScheduleTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.items.count
    }
}

extension ScheduleTableViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        
        return section.header
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = self.sections[indexPath.section]
        let row = section.items[indexPath.row]
        
        return ScheduleTableCell.cell(forTableView: tableView, indexPath: indexPath, session: row.session!)
    }
}

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
    var session : Session?
    
    static func cellIdentifier() -> String {
        return "ScheduleTableCell"
    }
    
    static func cell(forTableView tableView: UITableView, indexPath: IndexPath, session: Session) -> ScheduleTableCell {
        let cell : ScheduleTableCell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableCell.cellIdentifier(), for: indexPath) as! ScheduleTableCell
        
        cell.titleLabel?.text = session.title
        cell.roomLabel?.text = session.rooms[0]
        cell.session = session
        
        return cell
    }
}

class ScheduleTableViewController : UITableViewController {
    var sections = Array<ScheduleTableRow>()
    var sessions : Array<Session> = Array<Session>.init() {
        didSet {
            self.data = Dictionary<Date, Array<Session>>()
            self.setupSections()
        }
    }
    var data = Dictionary<Date, Array<Session>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSession" {
            let vc = segue.destination as! SessionViewController
            let cell = sender as! ScheduleTableCell
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

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
    var viewController : ScheduleCollectionViewController?
    
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
    var sessions : Array<Session>?
    
    var sections = Array<ContainerRow>()
    
    var scrollDelegate : UIScrollViewDelegate?
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: { _ in
            DispatchQueue.main.async {
               self.collectionView?.reloadData()
            }
        })
    }
    
    func setSessions(_ sessions : Array<Session>) {
        self.sessions = sessions
        
        self.setupSections()
    }
    
    func setupSections() {
        var sections : Array<ContainerRow> = []
        var rows : Array<ContainerRow> = []
        
        let dayFormatter = DateFormatter.init()
        dayFormatter.dateFormat = "EEEE"
        
        for session in self.sessions! {
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
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScheduleCollectionViewController") as! ScheduleCollectionViewController
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

extension ContainerViewController {
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewWillBeginDragging!(scrollView)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewDidEndDecelerating!(scrollView)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollDelegate?.scrollViewDidScroll!(scrollView)
    }
}

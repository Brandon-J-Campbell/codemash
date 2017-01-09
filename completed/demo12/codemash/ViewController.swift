//
//  ViewController.swift
//  codemash
//
//  Created by Brandon Campbell on 10/6/16.
//  Copyright © 2016 Brandon Campbell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tabSelectorView : ScrollSelectorView?
    var tabsArray = Array<Dictionary<String, String>>()
    
    var containerViewController : ContainerViewController?
    var sessions : Array<Session> = Array<Session>.init()
    var data = Dictionary<String, Array<Session>>()
    var isDragging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            } else {
                print("Error!! Unable to load SessionsData.json")
            }
        }
        
        self.sessions = rawSessions.sorted()
        
        self.tabSelectorView?.delegate = self
        
        let dayFormatter = DateFormatter.init()
        dayFormatter.dateFormat = "EEEE"
        
        for session in self.sessions {
            let day = dayFormatter.string(from: session.startTime)
            
            if data[day] == nil {
                data[day] = Array<Session>()
                var dict = Dictionary<String, String>()
                dict["Title"] = day
                dict["Value"] = day
                self.tabsArray.append(dict)
            }
            data[day]?.append(session)
        }
        
        self.containerViewController?.setSessions(self.sessions)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabSelectorView?.setValues(self.tabsArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedContainerViewController" {
            self.containerViewController = segue.destination as? ContainerViewController
            self.containerViewController?.scrollDelegate = self
        }
    }
    
    @IBAction func dayButtonPressed(sender : AnyObject?) {
        let button = sender as! UIButton
        
        self.containerViewController?.collectionView?.scrollRectToVisible(CGRect.init(x: Double(Int((self.containerViewController?.collectionView?.bounds.size.width)!) * button.tag), y: 0.0, width: Double((self.containerViewController?.collectionView?.bounds.size.width)!), height: 1.0), animated: true)
    }
}

extension ViewController : ScrollSelectorViewDelegate {
    func selector(selector: ScrollSelectorView, didScroll offsetPercent : CGFloat) {
        self.containerViewController?.collectionView?.setContentOffset(CGPoint(x:((((self.containerViewController?.collectionView?.bounds.size.width)! * CGFloat((self.tabsArray.count))) * offsetPercent) * -1), y: 0.0), animated: false)
    }
    
    func selector(selector: ScrollSelectorView, valueChanged index: Int) {
        self.containerViewController?.collectionView?.scrollRectToVisible(CGRect.init(x: Double(Int((self.containerViewController?.collectionView?.bounds.size.width)!) * index), y: 0.0, width: Double((self.containerViewController?.collectionView?.bounds.size.width)!), height: 1.0), animated: true)
    }
}

extension ViewController : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDragging = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isDragging = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isDragging {
            if scrollView.contentSize.width > 0 {
                self.tabSelectorView?.setScrollPercentage((scrollView.contentOffset.x * -1.0) / scrollView.contentSize.width)
            }
        }
    }
}

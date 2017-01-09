//
//  ScrollSelectorView.swift
//  codemash
//
//  Created by Brandon Campbell on 1/7/17.
//  Copyright © 2017 Brandon Campbell. All rights reserved.
//

import Foundation
import UIKit

protocol ScrollSelectorViewDelegate {
    func selector(selector : ScrollSelectorView, valueChanged index : Int)
    func selector(selector : ScrollSelectorView, didScroll offsetPercent : CGFloat)
}

class ScrollSelectorView : UIView {
    @IBOutlet var selectorContentView : UIView?
    @IBOutlet var selectorScrollView : UIScrollView?
    @IBOutlet var selectorContentViewWidth : NSLayoutConstraint?
    @IBOutlet var selectorIndicatorWidth : NSLayoutConstraint?
    var selectorValues : Array<Dictionary<String, String>>?
    var tabsArray = Array<ScrollSelectorTabView>()
    var isDragging : Bool = false
    var leftEdgeContraint : NSLayoutConstraint?
    var rightEdgeConstraint : NSLayoutConstraint?
    var currentTab : ScrollSelectorTabView?
    var selectionsPerPage = 1
    var delegate : ScrollSelectorViewDelegate?
    
    override func layoutSubviews() {
        let fadeWidth : CGFloat = 100.0
        
        let maskLayer = CALayer.init()
        maskLayer.frame = self.bounds
        
        let solidLayer = CALayer.init()
        solidLayer.backgroundColor = UIColor.white.cgColor
        
        var solidRect = CGRect.zero
        solidRect.size = self.bounds.size
        solidRect.origin.x = fadeWidth
        solidRect.size.width -= solidRect.origin.x + fadeWidth
        
        solidLayer.frame = solidRect
        maskLayer.addSublayer(solidLayer)
        
        let leftLayer = CAGradientLayer.init()
        leftLayer.frame = CGRect.init(x: 0.0, y: 0.0, width: fadeWidth, height: self.bounds.size.height)
        leftLayer.colors = [UIColor.clear.cgColor, self.backgroundColor?.cgColor ?? UIColor.black.cgColor]
        leftLayer.startPoint = CGPoint.zero
        leftLayer.endPoint = CGPoint.init(x: 1.0, y: 0.0)
        maskLayer.addSublayer(leftLayer)
        
        let rightLayer = CAGradientLayer.init()
        rightLayer.frame = CGRect.init(x: self.bounds.size.width - fadeWidth, y: 0.0, width: fadeWidth, height: self.bounds.size.height)
        rightLayer.colors = [self.backgroundColor?.cgColor ?? UIColor.black.cgColor, UIColor.clear.cgColor]
        rightLayer.startPoint = CGPoint.zero
        rightLayer.endPoint = CGPoint.init(x: 1.0, y: 0.0)
        maskLayer.addSublayer(rightLayer)
        
        self.layer.mask = maskLayer
        
        self.updateEdgeOffsets()
    }
    
    func setValues(_ values : Array<Dictionary<String, String>>) {
        self.selectorValues = values
        
        self.setupContentView(self.bounds.size)
    }
    
    func updateEdgeOffsets() {
        let halfWidth = Int(self.bounds.size.width / 2)
        let tabsContentMidpoint = ((120 * self.selectionsPerPage) / 2)
        let tabsSpacingMidpoint = ((22 * (self.selectionsPerPage - 1)) / 2)
        let edgeOffset = halfWidth - tabsContentMidpoint - tabsSpacingMidpoint
        
        self.leftEdgeContraint?.constant = CGFloat(edgeOffset > 0 ? edgeOffset : 0)
        self.rightEdgeConstraint?.constant = CGFloat(edgeOffset > 0 ? edgeOffset : 0) * -1.0
        self.selectorIndicatorWidth?.constant = CGFloat(142 * self.selectionsPerPage - 22)
        self.selectorContentViewWidth?.constant = CGFloat(2 * (tabsContentMidpoint + tabsSpacingMidpoint + edgeOffset))
        self.setNeedsDisplay()
    }
    
    func setupContentView(_ size : CGSize) {
        self.selectorIndicatorWidth?.constant = CGFloat(142 * self.selectionsPerPage - 22)
        
        let numberOfTabs = self.selectorValues?.count
        var tabs = self.tabsArray
        
        var i = 0
        
        while i < numberOfTabs! {
            let tab = ScrollSelectorTabView.init()
            tab.translatesAutoresizingMaskIntoConstraints = false
            
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ScrollSelectorView.tabPressed(_:)))
            tapGesture.numberOfTapsRequired = 1
            tapGesture.cancelsTouchesInView = false
            tab.addGestureRecognizer(tapGesture)
            
            tabs.append(tab)
            
            i += 1
        }
        self.tabsArray = tabs
        
        i = (self.selectorContentView?.subviews.count)! - 1
        while i >= 0 {
            let view = self.selectorContentView?.subviews[i]
            view?.removeFromSuperview()
            
            i -= 1
        }
        
        let halfWidth = Int(self.bounds.size.width / 2)
        let tabsContentMidpoint = ((120 * self.selectionsPerPage) / 2)
        let tabsSpacingMidpoint = ((22 * (self.selectionsPerPage - 1)) / 2)
        let edgeOffset = halfWidth - tabsContentMidpoint - tabsSpacingMidpoint
        
        if numberOfTabs! > 0 {
            i = 0
            while i < numberOfTabs! {
                let tabView = self.tabsArray[i]
                tabView.tag = i
                let dictionary = self.selectorValues?[i]
                tabView.titleLabel?.text = dictionary?["Title"]
                
                i += 1
            }
            
            let firstTabView = self.tabsArray[0]
            self.selectorContentView?.addSubview(firstTabView)
            
            var viewsDictionary = Dictionary<String, UIView>()
            viewsDictionary["firstTabView"] = firstTabView
            
            //Fill vertical space
            self.selectorContentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[firstTabView]-0-|",
                                                                                    options: [],
                                                                                    metrics: nil,
                                                                                    views: viewsDictionary))
            
            if numberOfTabs! > 1 {
                self.leftEdgeContraint = NSLayoutConstraint.init(item: firstTabView,
                                                                 attribute: NSLayoutAttribute.left,
                                                                 relatedBy: NSLayoutRelation.equal,
                                                                 toItem: self.selectorContentView,
                                                                 attribute: NSLayoutAttribute.left,
                                                                 multiplier: 1.0,
                                                                 constant: CGFloat(edgeOffset))
                self.selectorContentView?.addConstraint(leftEdgeContraint!)
                
                self.selectorContentView?.addConstraint(NSLayoutConstraint.init(item: firstTabView,
                                                                 attribute: NSLayoutAttribute.width,
                                                                 relatedBy: NSLayoutRelation.equal,
                                                                 toItem: nil,
                                                                 attribute: NSLayoutAttribute.notAnAttribute,
                                                                 multiplier: 1.0,
                                                                 constant: 120))
                
                
            } else {
                let offset = (size.width / 2) - (120 / 2)
                self.selectorContentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(offset)-[firstTabView]-\(offset)-|",
                                                                                        options: [],
                                                                                        metrics: nil,
                                                                                        views: viewsDictionary))
            }
            
            var previousView = firstTabView
            
            i = 1
            while i < numberOfTabs! - 1 {
                let currentView = self.tabsArray[i]
                
                self.selectorContentView?.addSubview(currentView)
                
                viewsDictionary.removeAll()
                viewsDictionary["currentView"] = currentView
                viewsDictionary["previousView"] = previousView
                
                //Fill vertical space
                self.selectorContentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[currentView]-0-|",
                                                                                        options: [],
                                                                                        metrics: nil,
                                                                                        views: viewsDictionary))
                
                //Current tab should be immediately to the right of the previous tab
                self.selectorContentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[previousView]-22-[currentView]",
                                                                                        options: [],
                                                                                        metrics: nil,
                                                                                        views: viewsDictionary))
                
                //All tabs should be equal widths
                self.selectorContentView?.addConstraint(NSLayoutConstraint.init(item: currentView,
                                                                                attribute: NSLayoutAttribute.width,
                                                                                relatedBy: NSLayoutRelation.equal,
                                                                                toItem: firstTabView,
                                                                                attribute: NSLayoutAttribute.width,
                                                                                multiplier: 1.0,
                                                                                constant: 0))
                
                previousView = currentView
                
                i += 1
            }
            
            if numberOfTabs! > 1 {
                let lastTabView = self.tabsArray[numberOfTabs! - 1]
                
                self.selectorContentView?.addSubview(lastTabView)
                
                viewsDictionary.removeAll()
                viewsDictionary["lastTabView"] = lastTabView
                viewsDictionary["previousView"] = previousView
                
                //Fill vertical space
                self.selectorContentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[lastTabView]-0-|",
                                                                                        options: [],
                                                                                        metrics: nil,
                                                                                        views: viewsDictionary))
                
                //Current tab should be immediately to the right of the previous tab
                self.selectorContentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[previousView]-22-[lastTabView]",
                                                                                        options: [],
                                                                                        metrics: nil,
                                                                                        views: viewsDictionary))
                
                self.rightEdgeConstraint = NSLayoutConstraint.init(item: lastTabView,
                                                                 attribute: NSLayoutAttribute.right,
                                                                 relatedBy: NSLayoutRelation.equal,
                                                                 toItem: self.selectorContentView,
                                                                 attribute: NSLayoutAttribute.right,
                                                                 multiplier: 1.0,
                                                                 constant: CGFloat(edgeOffset >= 0 ? edgeOffset : 0) * -1.0)
                self.selectorContentView?.addConstraint(self.rightEdgeConstraint!)
                
                //All tabs should be equal widths
                self.selectorContentView?.addConstraint(NSLayoutConstraint.init(item: lastTabView,
                                                                                attribute: NSLayoutAttribute.width,
                                                                                relatedBy: NSLayoutRelation.equal,
                                                                                toItem: firstTabView,
                                                                                attribute: NSLayoutAttribute.width,
                                                                                multiplier: 1.0,
                                                                                constant: 0))
            
            }
            
            
            self.selectorContentViewWidth?.constant = CGFloat((numberOfTabs! * 142) - 22 + (edgeOffset * 2))
        }
    }
    
    func selectTabWithValue(value : String) {
        var i = 0
        
        while i < self.selectorValues!.count {
            let dict = self.selectorValues![i]
            if dict["Value"] == value {
                let tab = self.tabsArray[i]
                self.currentTab?.setSelected(false)
                tab.setSelected(true)
                self.currentTab = tab
            }
            i += 1
        }
    }
    
    func tabPressed(_ sender : UITapGestureRecognizer) {
        let view = sender.view
        
        let tab = self.tabsArray[(view?.tag)!]
        
        tab.setSelected(true)
        self.currentTab!.setSelected(false)
        self.currentTab = tab
        
        self.selectorScrollView?.setContentOffset(CGPoint.init(x: (self.currentTab?.frame.midX)! - (self.bounds.size.width / 2.0) - 1, y: 0.0), animated: true)
        
        self.delegate?.selector(selector: self, valueChanged: (view?.tag)!)
    }
    
    func setScrollPercentage(_ percentage : CGFloat) {
        self.selectorScrollView?.setContentOffset(CGPoint.init(x: (((self.selectorScrollView?.contentSize.width)! - (self.bounds.size.width - CGFloat(142 * self.selectionsPerPage))) * percentage) * -1, y: 0.0), animated: false);
        
        let labelWidth : CGFloat = 142.0;
        let index = Int((self.selectorScrollView?.contentOffset.x)! / labelWidth);
        
        if index < self.tabsArray.count {
            let tab = self.tabsArray[index]
            tab.setSelected(true)
            self.currentTab?.setSelected(false)
            self.currentTab = tab;
        }
    }
}

extension ScrollSelectorView : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isDragging = true
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let labelWidth = CGFloat(142.0)
        let index = Int(targetContentOffset.pointee.x / labelWidth)
        targetContentOffset.pointee.x = CGFloat(index) * labelWidth
        
        let tab = self.tabsArray[index]
        tab.setSelected(true)
        self.currentTab?.setSelected(false)
        self.currentTab = tab
        
        self.delegate?.selector(selector: self, valueChanged: tab.tag)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isDragging {
            let a = (scrollView.contentOffset.x - (self.bounds.size.width / 2))
            let b = (scrollView.bounds.size.width / 2.0)
            let c = (self.bounds.size.width - CGFloat(142 * self.selectionsPerPage))
            self.delegate?.selector(selector: self, didScroll: ((a * -1) - b) / (scrollView.contentSize.width - c))
        }
    }
}

class ScrollSelectorTabView : UIView {
    var titleLabel : UILabel?
    
    init() {
        super.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 120.0, height: 44.0))
        
        self.titleLabel = UILabel.init()
        self.titleLabel!.font = UIFont.systemFont(ofSize: 12.0)
        self.titleLabel!.textColor = UIColor.white
        self.titleLabel!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.titleLabel!)
        self.addConstraint(NSLayoutConstraint.init(item: self.titleLabel!,
                                                   attribute: NSLayoutAttribute.centerX,
                                                   relatedBy: NSLayoutRelation.equal,
                                                   toItem: self,
                                                   attribute: NSLayoutAttribute.centerX,
                                                   multiplier: 1.0,
                                                   constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint.init(item: self.titleLabel!,
                                                   attribute: NSLayoutAttribute.centerY,
                                                   relatedBy: NSLayoutRelation.equal,
                                                   toItem: self,
                                                   attribute: NSLayoutAttribute.centerY,
                                                   multiplier: 1.0,
                                                   constant: 0.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSelected(_ selected : Bool) {
        if selected {
            self.titleLabel!.font = UIFont.boldSystemFont(ofSize: 12.0)
        } else {
            self.titleLabel!.font = UIFont.systemFont(ofSize: 12.0)
        }
    }
}

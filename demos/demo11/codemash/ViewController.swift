//
//  ViewController.swift
//  codemash
//
//  Created by Brandon Campbell on 10/6/16.
//  Copyright © 2016 Brandon Campbell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var containerViewController : ContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedContainerViewController" {
            self.containerViewController = segue.destination as? ContainerViewController
        }
    }
    
    @IBAction func dayButtonPressed(sender : AnyObject?) {
        let button = sender as! UIButton
        
        self.containerViewController?.collectionView?.scrollRectToVisible(CGRect.init(x: Double(Int((self.containerViewController?.collectionView?.bounds.size.width)!) * button.tag), y: 0.0, width: Double((self.containerViewController?.collectionView?.bounds.size.width)!), height: 1.0), animated: true)
    }
}


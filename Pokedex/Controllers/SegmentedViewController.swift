//
//  SegmentedViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit

class SegmentedViewController: UIViewController {

    @IBOutlet weak var viewSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var collectionViewContainer: UIView!
    
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.collectionViewContainer.isHidden = true
            self.tableViewContainer.isHidden = false
        } else {
            self.tableViewContainer.isHidden = true
            self.collectionViewContainer.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewContainer.isHidden = true
        self.tableViewContainer.isHidden = false
    }
}

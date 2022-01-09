//
//  ViewController.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/8/22.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    private lazy var searchController: UISearchController = {
        let sController = UISearchController(searchResultsController: nil)
        return sController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


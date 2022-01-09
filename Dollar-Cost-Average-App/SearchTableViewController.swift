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
        sController.searchResultsUpdater = self
        sController.delegate = self
        sController.obscuresBackgroundDuringPresentation = false
        sController.searchBar.placeholder = "Enter a company name or symbol"
        sController.searchBar.autocapitalizationType = .allCharacters
        return sController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        establishNavBar()
        
    }
    
    private func establishNavBar() {
        navigationItem.searchController = searchController
    }


}

extension SearchTableViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    
func updateSearchResults(for searchController: UISearchController) {
   
    }
}

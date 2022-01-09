//
//  ViewController.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/8/22.
//

import UIKit
import Combine

class SearchTableViewController: UITableViewController {
    
//MARK: When building own app: remember to adjust contraints on tableView cell items, link the class of the SearchTableViewController ("Custom CLass") to the cellID, and set the cell identifier!
    
    private lazy var searchController: UISearchController = {
        let sController = UISearchController(searchResultsController: nil)
        sController.searchResultsUpdater = self
        sController.delegate = self
        sController.obscuresBackgroundDuringPresentation = false
        sController.searchBar.placeholder = "Enter a company name or symbol"
        sController.searchBar.autocapitalizationType = .allCharacters
        return sController
    }()
    
    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>() //observer to publisher
    @Published private var searchQuery = String()  // @Published makes the search query observable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        establishNavBar()
        observeFormText()
        //performSearch()
        
    }
    
    
    
    private func establishNavBar() {
        navigationItem.searchController = searchController
    }
    
    private func observeFormText() {
        
        $searchQuery.debounce(for: .milliseconds(500), scheduler: RunLoop.main).sink { (searchQuery) in
            self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { [unowned self] (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { (searchResults) in
                print(searchResults)
            }.store(in: &self.subscribers)
            print(searchQuery)
        }.store(in: &subscribers)
        //debounce creates a small lag, to slow the API a but in case of fast typers
    }
    
    
    private func performSearch() {


    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        return cell
    }

}

extension SearchTableViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    
func updateSearchResults(for searchController: UISearchController) {
    
    guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
    
    self.searchQuery = searchQuery
    
    }
}

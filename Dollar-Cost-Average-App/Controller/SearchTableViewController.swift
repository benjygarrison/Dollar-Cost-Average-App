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
//MARK: To add animation using cocoapods, see section 4.12
    
    
    private enum Mode {
        case onboarding
        case search
    }
    
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
    private var searchResults: SearchResults?
    @Published private var mode: Mode = .onboarding // $ sets the listener
    private var subscribers = Set<AnyCancellable>() // listener for var below, set with &subscribers
    @Published private var searchQuery = String()  // @Published makes the search query observable, $ sets the listener
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        establishNavBar()
        observeFormText()
        setUpTableView()
        
    }
    
    
    
    private func establishNavBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    
    private func setUpTableView() {
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
    }
    
    
    private func observeFormText() {
        
        $searchQuery.debounce(for: .milliseconds(250), scheduler: RunLoop.main).sink { [unowned self] (searchQuery) in
            guard !searchQuery.isEmpty else { return }
            self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { (completion) in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished: break
                }
            } receiveValue: { (searchResults) in
                self.searchResults = searchResults
                self.tableView.reloadData()
                self.tableView.isScrollEnabled = true
            }.store(in: &self.subscribers)
            print(searchQuery)
        }.store(in: &subscribers)
        //debounce creates a small lag, to slow the API call a bit in case of fast typers
        
        $mode.sink { [unowned self] (mode) in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                self.tableView.backgroundColor = .systemBackground
            }
        }.store(in: &subscribers)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchTableViewCell
        
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.row]
            cell.configure(with: searchResult)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.item]
            let symbol = searchResult.symbol
            handleSelection(for: symbol, searchResult: searchResult)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func handleSelection(for symbol: String, searchResult: SearchResult) {
        
        apiService.fetchTimeSeriesMonthlyAdjusted(keywords: symbol).sink { (completionResult) in
            switch completionResult {
            case .failure(let error):
                print(error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] timeSeriesMonthlyAdjusted in
            
            let asset = Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
            self?.performSegue(withIdentifier: "showCalculator", sender: asset)
            print("success: \(timeSeriesMonthlyAdjusted.getMonthInfo())")
        }.store(in: &subscribers)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalculator", let destination = segue.destination as? CalculatorTableViewController, let asset = sender as? Asset {
            destination.asset = asset
        }
    }
    
}

extension SearchTableViewController : UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
    
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else { return }
    
        self.searchQuery = searchQuery
    
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
    
}

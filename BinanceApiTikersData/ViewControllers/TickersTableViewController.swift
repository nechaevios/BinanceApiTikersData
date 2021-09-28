//
//  TickersTableViewController.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import UIKit

class TickersTableViewController: UITableViewController {
    
    private var tickers: [Ticker] = []
    private var filteredTickers: [Ticker] = []
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private var spinnerView: UIActivityIndicatorView?
    
    private var tickersRefreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        return refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinnerView = runSpinner(in: view)
        self.refreshControl = tickersRefreshControl
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    @objc private func refreshTable(sender: UIRefreshControl) {
        fetchAllPrices()
        sender.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTickers.count
        }
        return tickers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tickerCell", for: indexPath) as! TickerCell
        
        let cellData = isFiltering ? filteredTickers[indexPath.row] : tickers[indexPath.row]
        
        cell.configure(with: cellData)
        
        return cell
    }
    
}

// MARK: Navigation
extension TickersTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedTicker = isFiltering ? filteredTickers[indexPath.row] : tickers[indexPath.row]

        let singleTickerVC = segue.destination as! SingleTickerViewController
        singleTickerVC.selectedTicker = selectedTicker
        singleTickerVC.fetchTickerOrderBook()
        singleTickerVC.fetchSingleTickerData()
        
    }
}

// MARK: Networking
extension TickersTableViewController {
    func fetchAllPrices() {
        NetworkManager.shared.fetch(dataType: [Ticker].self, from: ApiEndpoint.allTickers.rawValue) { result in
            switch result {
            case .success(let tickersData):
                self.tickers = tickersData
                self.tableView.reloadData()
                self.spinnerView?.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension TickersTableViewController {
    private func runSpinner(in view: UIView) -> UIActivityIndicatorView{
        let activitySpinner = UIActivityIndicatorView(style: .large)
        activitySpinner.hidesWhenStopped = true
        activitySpinner.center = view.center
        
        activitySpinner.startAnimating()
        
        view.addSubview(activitySpinner)
        
        return activitySpinner
    }
}

extension TickersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentWithText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentWithText (_ searchText: String) {
        filteredTickers = tickers.filter({ ticker in
            ticker.symbol.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}

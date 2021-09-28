//
//  TickersTableViewController.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import UIKit

class TickersTableViewController: UITableViewController {
    
    var tickers: [Ticker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tickers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tickerCell", for: indexPath) as! TickerCell
        let tickerData = tickers[indexPath.row]
        
        cell.configure(with: tickerData)
        
        return cell
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
            case .failure(let error):
                print(error)
            }
        }
    }
}

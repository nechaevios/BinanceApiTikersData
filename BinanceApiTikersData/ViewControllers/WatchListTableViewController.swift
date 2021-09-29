//
//  WatchListTableViewController.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import UIKit

class WatchListTableViewController: UITableViewController {
    
    private var sortedWatchList = BinanceTickers.shared.generateWatchList().sorted(by: < )
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedWatchList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tickerCell", for: indexPath) as! TickerCell
        let cellData = sortedWatchList[indexPath.row]
        cell.configure(with: cellData)
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let selectedTicker = sortedWatchList[indexPath.row]
        if let singleTickerVC = segue.destination as? SingleTickerViewController {
            
            singleTickerVC.selectedTicker = selectedTicker
            //        singleTickerVC.fetchTickerOrderBook()
            //        singleTickerVC.fetchSingleTickerData()
            singleTickerVC.alamofireUpdateLastPrice()
            singleTickerVC.alamofireUpdateOrderBook()
        }
    }
}

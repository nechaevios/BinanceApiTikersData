//
//  MainCollectionViewController.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    
    let userActions = UserActions.allCases
    let myWatchlist = WatchList.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
        
        cell.ActionLabel.text = userActions[indexPath.item].rawValue
        return cell
        
    }
        
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .showAllTickers: performSegue(withIdentifier: "showAll", sender: nil)
        case .showWatchlist: performSegue(withIdentifier: "showWatchlist", sender: nil)
        }
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAll" {
            guard let tickersVC = segue.destination as?  TickersTableViewController else { return }
            tickersVC.fetchAllPrices()
        }
    }
    


}

extension MainCollectionViewController {
    enum UserActions: String, CaseIterable {
        case showAllTickers = "Show all tickers"
        case showWatchlist = "Show my watchlist"
    }
}

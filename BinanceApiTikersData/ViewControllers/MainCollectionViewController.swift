//
//  MainCollectionViewController.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    
    let userActions = UserActions.allCases
    
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
        case .about: showAlert(alertTitle: "By Sergey Nechaev", alertMessage: "From traders to traders. Contacts: sergey@nechaev.ru")
        }
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAll" {
            guard let tickersVC = segue.destination as?  TickersTableViewController else { return }
            tickersVC.fetchAllPrices()
        } else if segue.identifier == "showWatchlist" {
            if BinanceTickers.shared.generateWatchList().count == 0 {
                showAlert(alertTitle: "Ooops 🚧", alertMessage: "Watchlist is empty. Add some tickers to watchlist", shouldRedirect: true, to: "showAll")
            }
        }
        
    }
    
    private func redirectTo(segue identifier: String) {
        performSegue(withIdentifier: identifier, sender: nil)
        
    }
    
    private func showAlert(alertTitle: String, alertMessage: String, shouldRedirect: Bool = false, to identifier: String = "") {
        let alert = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        
        let okAction = shouldRedirect ? UIAlertAction(title: "OK", style: .default)
        { okAction in
            self.redirectTo(segue: identifier)
        } : UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
}

extension MainCollectionViewController {
    enum UserActions: String, CaseIterable {
        case showAllTickers = "Show all tickers"
        case showWatchlist = "Show my watchlist"
        case about = "About"
    }
    
}

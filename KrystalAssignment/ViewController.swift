//
//  ViewController.swift
//  KrystalAssignment
//
//  Created by Ravi Tripathi on 21/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedAsset: AssetsList?
    var data: AutoCompleteResponse? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search For Stocks"
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "openDetail", let controller = segue.destination as? StockDetailController else {
            return
        }
        controller.title = self.selectedAsset?.assetName
        controller.selectedAsset = self.selectedAsset
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data?.assetsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.data?.assetsList?[indexPath.row].assetName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedData = self.data?.assetsList?[indexPath.row] else {
            return
        }
        self.selectedAsset = selectedData
        performSegue(withIdentifier: "openDetail", sender: self)
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            return
        }
        NetworkManager.shared.getAutoComplete(withValue: searchText) { (response) in
            guard let response = response else {
                return
            }
            self.data = response
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.data = nil
    }
}

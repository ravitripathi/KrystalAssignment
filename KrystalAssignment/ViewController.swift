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
    var data: AutoCompleteResponse? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.delegate = self
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.data?.kristalList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.data?.kristalList?[indexPath.row].kristalName
        return cell
    }
}


extension ViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NetworkManager.shared.getAutoComplete(withValue: searchText) { (response) in
            guard let response = response else {
                return
            }
            self.data = response
        }
    }
    
    
    //    func getData() -> [Any]? {
    //        return self.data?.kristalList
    //    }
    //
    //    func textToDisplay(forData data: Any) -> String? {
    //        guard let data = data as? KristalList else {
    //            return nil
    //        }
    //        return data.kristalName
    //    }
}

//extension ViewController: RTSearchBarDelegate {
//    func didChange(text: String) {
//        NetworkManager.shared.getAutoComplete(withValue: text) { (response) in
//            guard let response = response else {
//                return
//            }
//            self.data = response
//            self.searchBar.reload()
//        }
//    }
//
//    func didSelect(withData data: Any) {
//    }
//}
//

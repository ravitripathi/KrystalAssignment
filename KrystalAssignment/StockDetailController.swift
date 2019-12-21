//
//  StockDetailController.swift
//  KrystalAssignment
//
//  Created by Ravi Tripathi on 21/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import UIKit
import RappleProgressHUD
//Name, Symbol, Currency,
//Last Price, Pricing Date, High Price and Low Price

class StockDetailController: UIViewController {

    enum RowType: CaseIterable {
        case Name
        case Symbol
        case Currency
        case LastPrice
        case PricingDate
        case HighPrice
        case LowPrice
    }
    
    @IBOutlet weak var tableView: UITableView!
    var selectedAsset: AssetsList?
    var assetDetail: AssetDetailResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        RappleActivityIndicatorView.startAnimatingWithLabel("Fetching Details", attributes: [RappleIndicatorStyleKey: RappleStyleApple])
        self.fetchDetails()
    }
    
    func fetchDetails() {
        guard let id = selectedAsset?.assetId, let type = selectedAsset?.assetType else {
            RappleActivityIndicatorView.stopAnimation()
            self.navigationController?.popViewController(animated: true)
            return
        }
        NetworkManager.shared.getAssetDetails(forID: id, assetType: type) { (assetDetail) in
            self.assetDetail = assetDetail
            self.tableView.reloadData()
            RappleActivityIndicatorView.stopAnimation()
        }
    }
    
}

extension StockDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch RowType.allCases[indexPath.row] {
        case .Name:
            cell.textLabel?.text = self.assetDetail?.contractName
        case .Symbol:
            cell.textLabel?.text = self.assetDetail?.symbol
        case .Currency:
            cell.textLabel?.text = self.assetDetail?.currency
        case .LastPrice:
            cell.textLabel?.text = "\(self.assetDetail?.lastPrice ?? 0.0)"
        case .PricingDate:
            cell.textLabel?.text = self.assetDetail?.pricingDate
        case .HighPrice:
            cell.textLabel?.text = "\(self.assetDetail?.highPrice ?? 0.0)"
        case .LowPrice:
            cell.textLabel?.text = "\(self.assetDetail?.lowPrice ?? 0.0)"
        }
        return cell
    }
}

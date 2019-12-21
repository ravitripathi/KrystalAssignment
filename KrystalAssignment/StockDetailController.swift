//
//  StockDetailController.swift
//  KrystalAssignment
//
//  Created by Ravi Tripathi on 21/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import UIKit
import RappleProgressHUD

class StockDetailController: UIViewController {

    enum RowType: String, CaseIterable {
        case name = "Name"
        case symbol = "Symbol"
        case currency = "Currency"
        case lastPrice = "Last Price"
        case pricingDate = "Pricing Date"
        case highPrice = "High Price"
        case lowPrice = "Low Price"
    }
    
    @IBOutlet weak var tableView: UITableView!
    var selectedAsset: AssetsList?
    var assetDetail: AssetDetailResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "StockDetailCell", bundle: nil), forCellReuseIdentifier: "stockDetailCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockDetailCell", for: indexPath) as! StockDetailCell
        switch RowType.allCases[indexPath.row] {
        case .name:
            cell.titleLabel.text = RowType.name.rawValue
            cell.valueLabel.text = self.assetDetail?.contractName
        case .symbol:
            cell.titleLabel.text = RowType.symbol.rawValue
            cell.valueLabel.text = self.assetDetail?.symbol
        case .currency:
            cell.titleLabel.text = RowType.currency.rawValue
            cell.valueLabel.text = self.assetDetail?.currency
        case .lastPrice:
            cell.titleLabel.text = RowType.lastPrice.rawValue
            cell.valueLabel.text = "\(self.assetDetail?.lastPrice ?? 0.0)"
        case .pricingDate:
            cell.titleLabel.text = RowType.pricingDate.rawValue
            cell.valueLabel.text = self.assetDetail?.pricingDate
        case .highPrice:
            cell.titleLabel.text = RowType.highPrice.rawValue
            cell.valueLabel.text = "\(self.assetDetail?.highPrice ?? 0.0)"
        case .lowPrice:
            cell.titleLabel.text = RowType.lowPrice.rawValue
            cell.valueLabel.text = "\(self.assetDetail?.lowPrice ?? 0.0)"
        }
        return cell
    }
}

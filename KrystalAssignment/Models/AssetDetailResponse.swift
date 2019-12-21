//
//  AssetDetailResponse.swift
//  KrystalAssignment
//
//  Created by Ravi Tripathi on 21/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import Foundation

class AssetDetailResponse: Codable {
    var contractName: String?
    var symbol: String?
    var exchange: String?
    var currency: String?
    var issuer: String?
    var country: String?
    var subclass: String?
    var pricingDate: String?
    var lastPrice: Double?
    var openPrice: Double?
    var highPrice: Double?
    var lowPrice: Double?
    var askPrice: Double?
    var bidPrice: Double?
    var volume: Int?
    var splitRatio: Int?
    var cashDividend: Int?
}

//
//  AutoCompleteResponse.swift
//  KrystalAssignment
//
//  Created by Ravi Tripathi on 21/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import Foundation

// MARK: - Sites
class AutoCompleteResponse: Codable {
    var kristalList: [KristalList]?
    var assetsList: [AssetsList]?
}

// MARK: - AssetsList
class AssetsList: Codable {
    var assetID: String?
    var assetName: String?
    var symbol: String?
    var isin: String?
    var exchange: String?
    var industry: String?
    var issuer: String?
    var assetType: String?
}

// MARK: - KristalList
class KristalList: Codable {
    var kristalID: String?
    var kristalName: String?
    var summary: String?
    var kristalImageURL: String?
    var kristalListDescription: String?
}

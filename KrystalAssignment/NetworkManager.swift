//
//  NetworkManager.swift
//  KrystalAssignment
//
//  Created by Ravi Tripathi on 21/12/19.
//  Copyright © 2019 Ravi Tripathi. All rights reserved.
//

import Alamofire
import RappleProgressHUD
import UIKit

enum Endpoints: String {
    case search = "/v2/kristals/kristalassetsearch"
    case details = "/v3/getassetdetails"
}


class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://staging.investo2o.com/assetmanager-ws/api"
    
    let headers: HTTPHeaders =
        ["user-id":"11225",
         "agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36",
         "access-token": "YjZmNmVlYjEtMGZiZi00NTM5LTgyYzMtMjZhZmQ5NDFkYTA3JVVTRVIlMTEyMjU=",
         "externaluser-id": "226",
         "accept": "application/json, text/plain, */*",
         "user-ip": "106.51.66.2"]
    
    
    func getAutoComplete(withValue value: String, completion: @escaping (AutoCompleteResponse?)->()) {
        let urlString = "\(baseURL)\(Endpoints.search.rawValue)"
        guard let url = URL(string: urlString) else {
            return
        }
        let param: Parameters = ["query": value]
        
        
        AF.request(url,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding(destination: .queryString),
                   headers: headers).response { (afData) in
                    
                    if let error = afData.error {
                        self.errorHandler(forAFError: error)
                        completion(nil)
                    }
                    
                    guard let data = afData.data else {
                        completion(nil)
                        return
                    }
                    let decoder = JSONDecoder()
                    let decodedResponse = try? decoder.decode(AutoCompleteResponse.self, from: data)
                    completion(decodedResponse)
        }
    }
    
    func getAssetDetails(forID id: String, assetType: String, completion: @escaping (AssetDetailResponse?)->()) {
        let urlString = "\(baseURL)\(Endpoints.details.rawValue)"
        guard let url = URL(string: urlString) else {
            return
        }
        let param: Parameters =
            ["asset": id,
             "assetType": assetType]
        AF.request(url,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding(destination: .queryString),
                   headers: headers).response { (afData) in
                    
                    if let error = afData.error {
                        self.errorHandler(forAFError: error)
                        completion(nil)
                    }
                    
                    guard let data = afData.data else {
                        completion(nil)
                        return
                    }
                    let decoder = JSONDecoder()
                    let decodedResponse = try? decoder.decode(AssetDetailResponse.self, from: data)
                    completion(decodedResponse)
        }
        
    }
    
    func errorHandler(forAFError error: AFError) {
        RappleActivityIndicatorView.stopAnimation()
        var errorString = ""
        switch error {
        case .invalidURL(let url):
            errorString = "Invalid URL: \(url) - \(error.localizedDescription)"
        case .parameterEncodingFailed( _):
            errorString = "Parameter encoding failed: \(error.localizedDescription)"
        case .multipartEncodingFailed( _):
            errorString = "Multipart encoding failed: \(error.localizedDescription)"
        case .responseValidationFailed( _):
            errorString = "Response validation failed: \(error.localizedDescription)"
        case .responseSerializationFailed( _):
            errorString = "Response serialization failed: \(error.localizedDescription)"
        default:
            errorString = "Unknown Error Occured"
        }
        let controller = UIAlertController(title: "Network Error", message: errorString, preferredStyle: .alert)
        UIApplication.shared.keyWindow?.topViewController()?.present(controller, animated: true, completion: nil)
    }
}


extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}

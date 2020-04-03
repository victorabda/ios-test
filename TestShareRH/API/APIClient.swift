//
//  APIClient.swift
//  TestShareRH
//
//  Created by Victor B D Almeida on 02/04/20.
//  Copyright © 2020 Victor B D Almeida. All rights reserved.
//

import Foundation

class APIClient {
    
    static let token = "732fc17278a1d21c733573814fb76eaeb1f27d74"
    static let clientId = "2c22f0745d26399"
    static let clientSecret = "aaa8fe76c1c4fb43ed879765372cd17f4d1f3101"
    static let refreshToken = "732fc17278a1d21c733573814fb76eaeb1f27d74"
    
    
    // MARK: -
    static func getGallery(page: Int, text: String?, completion: @escaping ([[String: Any]]) -> ()) {
        let query = text ?? "cats"
        var getRequest = URLRequest(url: URL(string: "https://api.imgur.com/3/gallery/search/\(page)/?q=\(query)")!)
        getRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        getRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: getRequest) { data, response, error in
            guard(error == nil) else {
                print("\(String(describing: error))")
                return
            }

            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                guard let newValue = jsonResult as? [String: Any] else {
                    print("invalid format")
                    return
                }
                if let gallery = newValue["data"] as? [[String: Any]] {
                    completion(gallery)
                }
            } catch {
                print("Could not parse data as Json \(error)")
            }
        }.resume()
    }
    
    static func parseAllImages(data: [[String: Any]]) -> [String] {
        var array = [String]()
        
        for oneRecord in data {
            if let images = oneRecord["images"] as? [[String: Any]] {
                for oneImage in images {
                    if let link = oneImage["link"] as? String {
                        // print("Link \(link) - Ext: \(link.fileExtension())")
                        array.append(link)
                    }
                }
            }
        }
        
        return array
    }
}

//
//  DogListGetAPI.swift
//  DogViewApp_School
//
//  Created by user on 2023/09/12.
//

import Foundation

class ListAllBreedsAPI {

    let urlString = "https://dog.ceo/api/breeds/list/all"

    let apiKey = "live_Sc3u7yJ0eTrA4wME1aBn37eBwFjuadX8caR7NvYbNTpJsWhDN8EokvOTjLsxdIAD"
    let apiKeySetString = "?api_key="
    
    func getListAllBreedsAPI(success: @escaping([String: [String]]) -> Void) {
        let apiKeyString = apiKeySetString + apiKey
        let url = urlString + apiKeyString
        
        guard let requestUrl = URL(string: url) else {
            // コードミスでしか通らない
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            // 通信エラー
            if let error = error {
                print("Unexpected error: \(error.localizedDescription).")
                return
            }
            
            // HTTPレスポンスコードエラー
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print("Request Failed - Status Code: \(response.statusCode).")
                    return
                }
            }
            
            // データのパース
            if let data = data {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let dogInfos = jsonDict?["message"] as? [String: [String]] {
                        success(dogInfos)
                    } else {
                        print("jsonError :\(String(describing: jsonDict))")
                    }
                } catch {
                    print("Error")
                }
            } else {
                print("Unexpected error.")
            }
            
        }.resume()
    }

}

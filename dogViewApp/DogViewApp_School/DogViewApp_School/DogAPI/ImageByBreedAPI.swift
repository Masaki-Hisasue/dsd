//
//  ImageByBreed.swift
//  DogViewApp_School
//
//  Created by user on 2023/09/13.
//

import UIKit

class ImageByBreedAPI {

    let urlBaseString = "https://dog.ceo/api/breed/SELECTED_DOG/images"
    let replaceString = "SELECTED_DOG"

    func getBreedImageUrlAPI(breed: BreedsData ,success: @escaping([String]) -> Void) {
        
        let urlString = self.urlBaseString.replacingOccurrences(of: self.replaceString , with: breed.dogBreeds)
        
        guard let requestUrl = URL(string: urlString) else {
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
                    if let imageUrls = jsonDict?["message"] as? [String] {
                        success(imageUrls)
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

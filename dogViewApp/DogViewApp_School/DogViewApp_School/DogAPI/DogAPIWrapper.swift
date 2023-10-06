//
//  DogAPIWrapper.swift
//  DogViewApp_School
//
//  Created by user on 2023/09/12.
//

import UIKit

class DogAPIWrapper {

    func getDogList(success: @escaping([BreedsData]) -> Void) {
        let api = ListAllBreedsAPI()
        api.getListAllBreedsAPI { breedsInfo in
            var breadList: [BreedsData] = []
            for breed in breedsInfo {
                let breed = BreedsData(dobBreeds: breed.key, subBreeds: breed.value)
                breadList.append(breed)
            }
            success(breadList)
        }
    }
    
    func getDogImageData(breed: BreedsData, success: @escaping([DogImageData]) -> Void) {
        let api = ImageByBreedAPI()
        api.getBreedImageUrlAPI(breed: breed) { urlList in
            var dogImageDataList: [DogImageData] = []
            for url in urlList {
                let dogImageData = DogImageData(urlString: url)
                dogImageDataList.append(dogImageData)
            }
            success(dogImageDataList)
        }
    }
        
}

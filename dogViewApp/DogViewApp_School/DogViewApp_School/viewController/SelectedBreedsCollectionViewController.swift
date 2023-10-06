//
//  SelectedBreedsCollectionViewController.swift
//  DogViewApp_School
//
//  Created by user on 2023/09/13.
//

import UIKit
import AlamofireImage // 画像をキャッシュして使うためにライブラリ使用

class SelectedBreedsCollectionViewController: UICollectionViewController {
    
    @IBOutlet var dogImageCollectionView: UICollectionView!
    
    let dogImageViewCellIdentifier = "dogCollectionViewCell"
    
    var selectedBreed: BreedsData?
    var dogImageList: [DogImageData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.selectedBreed?.dogBreeds
        // データ利用のために設定
        dogImageCollectionView.delegate = self
        dogImageCollectionView.dataSource = self
        
        // 表示画像データ取得
        self.getImageData()
    }
    
    // 画像データ取得
    private func getImageData() {
        let api = DogAPIWrapper()
        guard let breed = self.selectedBreed else {
            // 例外:セグエで渡すのに失敗したケース
            return
        }
        api.getDogImageData(breed: breed) { dogImageList in
            self.dogImageList = dogImageList
            self.refreshTableView()
        }
    }
    
    // 画面更新
    private func refreshTableView() {
        DispatchQueue.main.async {
            self.dogImageCollectionView.reloadData()
        }
    }

    // セル個数指定(delegate)
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dogImageList.count
    }

    // 個別セル情報更新（delegate）
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = self.dogImageCollectionView.dequeueReusableCell(withReuseIdentifier: dogImageViewCellIdentifier, for: indexPath) as? DogImageTileCollectionViewCell else {
            // 例外:とりあえず空で返す
            let cell = UICollectionViewCell()
            return cell
        }
        
        let dogImageData = self.dogImageList[indexPath.row]
        
        if let dogImageUrl = URL(string: dogImageData.urlString) {
            cell.dogImage.contentMode = UIImageView.ContentMode.scaleAspectFill
            cell.dogImage.af.setImage(withURL: dogImageUrl)
        }
        return cell
    }
    
    /// セグエで情報を受け渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectedDogPagingPage" {
            guard let dogPagingPageViewController = segue.destination as? DogPagingPageViewController
                  // let indexPath = sender as? IndexPath
            else {
                fatalError("Failed to prepare SelectedBreedsCollectionViewController.")
            }
            let indexData = self.dogImageCollectionView.indexPathsForSelectedItems
            guard let index = indexData?.first else {
                print("miss index")
                return
            }

            dogPagingPageViewController.firstIndex = index.row
            dogPagingPageViewController.pagingDogImageList = self.dogImageList
        }
    }
    
}


extension SelectedBreedsCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 端末サイズの半分のwidthとheightにして2列にする
        let width: CGFloat = dogImageCollectionView.frame.width / 2
        let height = width
        return CGSize(width: width, height: height)
    }
    
    // 間の線
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

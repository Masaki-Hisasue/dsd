//
//  DogListViewController.swift
//  DogViewApp_School
//
//  Created by user on 2023/09/12.
//

import UIKit

class DogListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let navigationBarTitile = "ホーム"

    var breedsList: [BreedsData] = []
    
    @IBOutlet weak var dogListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dogListTableView.delegate = self
        dogListTableView.dataSource = self
        
        self.navigationItem.title = navigationBarTitile
        self.prepareBreedsList()
    }
    
    // ランダムボタンタップ
    @IBAction func randumBarButtonTapped(_ sender: Any) {
        print("tappled randum")
    }
    
    // 右端の詳細箇所タップ
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        guard let cell = dogListTableView.dequeueReusableCell(withIdentifier: "dogListCell", for: indexPath) as? DogListTableViewCell else {
            // 例外:なにもしない
            return
        }
        let rowBreadData = breedsList[indexPath.row]
        print("dogName =  \(rowBreadData.dogBreeds)")
    }

    
    private func setBreedList(breedsList: [BreedsData]) {
        // 並び替えしてからセットする
        var sortedList = breedsList
        sortedList.sort(by: {$0.dogBreeds < $1.dogBreeds})
        self.breedsList = sortedList
    }
    
    private func refreshTableView() {
        DispatchQueue.main.async {
            self.dogListTableView.reloadData()
        }
    }
    
    private func prepareBreedsList() {
        let apiWrapper = DogAPIWrapper()
        apiWrapper.getDogList { breedsDatas in
            self.setBreedList(breedsList: breedsDatas)
            self.refreshTableView()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = dogListTableView.dequeueReusableCell(withIdentifier: "dogListCell", for: indexPath) as? DogListTableViewCell else {
            // 例外:とりあえず空で返す
            let cell = UITableViewCell()
            return cell
        }
        let rowBreadData = breedsList[indexPath.row]
    
        cell.dogName.text = rowBreadData.dogBreeds
        // 右端部分のボタンを設定
        if rowBreadData.hasSubBreeds() {
            cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    // Cell が選択された場合に解除しないとRejectされるらしいので追加
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// セグエで情報を受け渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBreedsSelectedTile" {
            if let indexPath = dogListTableView.indexPathForSelectedRow {
                guard let selectedBreedsCollectionViewController = segue.destination as? SelectedBreedsCollectionViewController else {
                    fatalError("Failed to prepare SelectedBreedsCollectionViewController.")
                }
                let rowBreadData = breedsList[indexPath.row]
                selectedBreedsCollectionViewController.selectedBreed = rowBreadData
            }
        }
    }

}

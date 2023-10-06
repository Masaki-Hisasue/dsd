//
//  DogPagingPageViewController.swift
//  DogViewApp_School
//
//  Created by user on 2023/09/14.
//

import UIKit
import AlamofireImage // 画像をキャッシュして使うためにライブラリ使用

class DogPagingPageViewController: UIPageViewController {

    var pagingDogImageList: [DogImageData]? = []
    var firstIndex: Int = 0

    var pageControl: UIPageControl!
    let pagingViewControlleridentifier = "SingleDogImageViewController"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.pageControl = UIPageControl()
        
        self.setUpPagingView()
    }
    
    private func setUpPagingView() {
        guard let imageViewController = self.getDogImageViewController(index: firstIndex) else {
            return
        }
        self.setViewControllers([imageViewController], direction: .forward, animated: true)
    }
    
    private func getDogImageViewController (index: Int) -> SingleDogImageViewController? {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let singleDogImageViewController = storyBoard.instantiateViewController(withIdentifier: pagingViewControlleridentifier) as? SingleDogImageViewController else {
            // 例外：作成失敗
            print("fail to prepare View")
            return nil
        }
        
        // viewの読み込みをして実体化する
        singleDogImageViewController.loadViewIfNeeded()
        guard let dogImageData = self.pagingDogImageList?[index] else {
            // 例外：遷移時にリスト未取得
            print("fail to prepare DogImageList")
            return nil
        }
        
        guard let dogImageUrl = URL(string: dogImageData.urlString) else {
            print("dogViewUrl is not url")
            return nil
        }
        
        singleDogImageViewController.index = index
        singleDogImageViewController.dogImageView.af.setImage(withURL: dogImageUrl)
        return singleDogImageViewController
    }

}

extension DogPagingPageViewController: UIPageViewControllerDataSource {

    // 前ページを返すDelegateメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = pageViewController.viewControllers?.first as? SingleDogImageViewController else {
            // 表示中のViewがない=不正に呼ばれたケース
            return nil
        }
        let index = vc.index
        let prevPageIndex = index - 1
        if prevPageIndex < 0 {
            return nil
        }
        
        guard let imageViewController = self.getDogImageViewController(index: prevPageIndex) else {
            return nil
        }
        return imageViewController
    }
    
    // 次ページを返すDelegateメソッド
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = pageViewController.viewControllers?.first as? SingleDogImageViewController else {
            // 表示中のViewがない=不正に呼ばれたケース
            return nil
        }
        let index = vc.index
        let afterPageIndex = index + 1
        // 個数とIndexの比較を合わせるために-1している
        if let dogList = self.pagingDogImageList,
            dogList.count - 1 < afterPageIndex {
            return nil
        }

        guard let imageViewController = self.getDogImageViewController(index: afterPageIndex) else {
            return nil
        }
        return imageViewController
    }
   
}

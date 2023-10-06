//
//  SingleDogImageViewController.swift
//  DogViewApp_School
//
//  Created by user on 2023/09/14.
//

import UIKit

class SingleDogImageViewController: UIViewController {

    @IBOutlet weak var dogImageView: UIImageView!
    
    @IBOutlet weak var baseScrollView: UIScrollView!
    
    var index = 0
    
    var imageScale = 1.0
    let defaultScale = 1.0
    let doubleTappedScale = 1.5
    let maximumScale = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ダブルタップ時のイベント登録
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(tappdDouble(sender:)))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        // scrollの設定
        baseScrollView.delegate = self
        self.setScrollView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 戻ってきた際に表示倍率を標準倍率に戻す
        self.baseScrollView.setZoomScale(defaultScale, animated: false)
        // ナビゲーションバーを復活
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setScrollView() {
        self.baseScrollView.maximumZoomScale = maximumScale
        self.baseScrollView.minimumZoomScale = defaultScale
        self.baseScrollView.bounces = false
    }
    
    private func setImageView() {
        let transScale = CGAffineTransform(scaleX: defaultScale, y: defaultScale)
        dogImageView.transform = transScale
    }
    
    @objc func tappdDouble(sender: UITapGestureRecognizer!){
        // ダブルタップで拡大or倍率を戻す
        if imageScale == defaultScale {
            imageScale = doubleTappedScale
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            imageScale = defaultScale
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        baseScrollView.setZoomScale(imageScale, animated: true)
    }

}

extension SingleDogImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.dogImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // 表示中ImageViewの倍率は画像のX座標を取得することで実現
        let nowImageScale = self.dogImageView.transform.a
        self.imageScale = nowImageScale
        if imageScale != defaultScale {
            navigationController?.setNavigationBarHidden(true, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
}

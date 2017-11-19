//
//  ViewController.swift
//  InfinityScrollView
//
//  Created by AmyF on 2017/11/19.
//  Copyright © 2017年 AmyF. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AFInfinityScrollViewDelegate {

    let imageBrowseView1 = AFInfinityScrollView()
    
    let imageBrowseView2 = AFInfinityScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(imageBrowseView1)
        imageBrowseView1.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(196)
        }
        
        self.view.addSubview(imageBrowseView2)
        imageBrowseView2.snp.makeConstraints { make in
            make.top.equalTo(imageBrowseView1.snp.bottom).offset(32)
            make.left.right.equalToSuperview()
            make.height.equalTo(256)
        }
        
        imageBrowseView1.imageURLs = [
            "https://pic4.zhimg.com/v2-aefb8e92fd65bcdaaf70bcbeec85747b_b.jpg",
            "https://pic4.zhimg.com/v2-501b8573174cc2a30790840ae7382927_b.jpg",
            "https://pic3.zhimg.com/v2-d2058c14b76d7ff0a9b78c30a556c25a_b.jpg",
            "https://pic4.zhimg.com/v2-6af2a92488fff02595f9420585c7a8df_b.jpg",
            "https://pic4.zhimg.com/v2-f03eef00980495955abc097a0da25ca7_b.jpg"
            ].flatMap { URL(string: $0) }
        imageBrowseView1.delegate = self
        imageBrowseView1.backgroundColor = .red
        
        imageBrowseView2.imageURLs = [
            "https://i.pximg.net/c/600x600/img-master/img/2017/11/05/00/25/26/65752703_p0_master1200.jpg",
            "https://i.pximg.net/c/600x600/img-master/img/2017/11/05/00/03/52/65752188_p0_master1200.jpg",
            "https://i.pximg.net/c/600x600/img-master/img/2017/10/27/20/36/47/65617348_p0_master1200.jpg",
            "https://i.pximg.net/c/600x600/img-master/img/2017/11/06/00/05/09/65770218_p0_master1200.jpg"
            ].flatMap { URL(string: $0) }
        imageBrowseView2.delegate = self
        imageBrowseView2.backgroundColor = .green
        imageBrowseView2.scrollDirection = .vertical
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func af(infinityView: AFInfinityScrollView, scrollTo index: Int) {
        print("\(infinityView) scroll to \(index)")
    }
    
    func af(infinityView: AFInfinityScrollView, didSelectItemAt index: Int) {
        print("\(infinityView) did select \(index)")
    }

}


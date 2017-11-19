//
//  ViewController.swift
//  InfinityScrollView
//
//  Created by AmyF on 2017/11/19.
//  Copyright © 2017年 AmyF. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let imageBrowseView = AFInfinityScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(imageBrowseView)
        imageBrowseView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(196)
        }
        
        imageBrowseView.imageURLs = [
            "https://i.pximg.net/c/600x600/img-master/img/2017/11/05/00/25/26/65752703_p0_master1200.jpg",
            "https://i.pximg.net/c/600x600/img-master/img/2017/11/05/00/03/52/65752188_p0_master1200.jpg",
            "https://i.pximg.net/c/600x600/img-master/img/2017/10/27/20/36/47/65617348_p0_master1200.jpg",
            "https://i.pximg.net/c/600x600/img-master/img/2017/11/06/00/05/09/65770218_p0_master1200.jpg"
            ].flatMap { URL(string: $0) }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


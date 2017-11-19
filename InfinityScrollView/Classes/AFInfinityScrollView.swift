//
//  AFInfinityScrollView.swift
//  InfinityScrollView
//
//  Created by AmyF on 2017/11/19.
//  Copyright © 2017年 AmyF. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol AFInfinityScrollViewDelegate: class {
    func af(infinityView: AFInfinityScrollView, didSelectItemAt index: Int)
}

class AFInfinityScrollView: UIView {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = self.scrollDirection
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AFInfinityCell.self, forCellWithReuseIdentifier: identifier)
        return collectionView
    }()
    fileprivate let identifier = "AFInfinityCell"
    
    var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = scrollDirection
                collectionView.reloadData()
            }
        }
    }
    
    var placeholderImage: UIImage?
    
    var imageURLs: [URL] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    weak var delegate: AFInfinityScrollViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI() {
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
}


extension AFInfinityScrollView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = imageURLs.count
        if count == 0 {
            count = 1
        }
        else if count > 1 {
            count += 2
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AFInfinityCell
        
        if imageURLs.count > 0 {
            var index = indexPath.item
            if index >= imageURLs.count {
                index = indexPath.item % imageURLs.count
            }
            cell.configure(url: imageURLs[index], placeholder: placeholderImage)
        }
        else {
            cell.configure(url: nil, placeholder: placeholderImage)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageURLs.count > 0 {
            var index = indexPath.item
            if index >= imageURLs.count {
                index = indexPath.item % imageURLs.count
            }
            self.delegate?.af(infinityView: self, didSelectItemAt: index)
        }
        else {
            self.delegate?.af(infinityView: self, didSelectItemAt: 0)
        }
    }
    
}

extension AFInfinityScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
}

class AFInfinityCell: UICollectionViewCell {
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupUI() {
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func configure(url: URL?, placeholder: UIImage?) {
        imageView.kf.setImage(with: url, placeholder: placeholder)
    }
}

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
    
    func af(infinityView: AFInfinityScrollView, scrollTo index: Int)
}

class AFInfinityScrollView: UIView {
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = self.scrollDirection
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AFInfinityCell.self, forCellWithReuseIdentifier: identifier)
        return collectionView
    }()
    fileprivate let identifier = "AFInfinityCell"
    
    open var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = scrollDirection
                collectionView.reloadData()
            }
        }
    }
    
    open override var contentMode: UIViewContentMode {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    open var placeholderImage: UIImage?
    
    open var imageURLs: [URL] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    open weak var delegate: AFInfinityScrollViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    fileprivate func setupUI() {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AFInfinityCell
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.callbackDidScroll()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.callbackDidScroll()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.callbackDidScroll()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let count = collectionView.numberOfItems(inSection: 0)
        if scrollDirection == .horizontal {
            var offsetX = collectionView.contentOffset.x
            if count >= 3 {
                if offsetX >= self.frame.width * CGFloat(count - 1) {
                    offsetX = self.frame.width
                    collectionView.contentOffset = CGPoint(x: offsetX, y: 0)
                }
                else if offsetX <= 0 {
                    offsetX = self.frame.width * CGFloat(count - 2)
                    collectionView.contentOffset = CGPoint(x: offsetX, y: 0)
                }
            }
        }
        else {
            var offsetY = collectionView.contentOffset.y
            if count >= 3 {
                if offsetY >= self.frame.height * CGFloat(count - 1) {
                    offsetY = self.frame.height
                    collectionView.contentOffset = CGPoint(x: 0, y: offsetY)
                }
                else if offsetY <= 0 {
                    offsetY = self.frame.height * CGFloat(count - 2)
                    collectionView.contentOffset = CGPoint(x: 0, y: offsetY)
                }
            }
        }
    }
    
    fileprivate func callbackDidScroll() {
        assert(self.frame.height > 0, "不能作为除数")
        assert(self.frame.width > 0, "不能作为除数")
        
        var index = 0
        switch scrollDirection {
        case .horizontal:
            index = Int(collectionView.contentOffset.x / self.frame.width)
        case .vertical:
            index = Int(collectionView.contentOffset.y / self.frame.height)
        }
        
        index = index < 0 ? imageURLs.count - 1 : index
        index = index >= imageURLs.count ? 0 : index
        
        self.delegate?.af(infinityView: self, scrollTo: index)
    }
}

class AFInfinityCell: UICollectionViewCell {
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    fileprivate func setupUI() {
        self.contentView.clipsToBounds = true
        
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func configure(url: URL?, placeholder: UIImage?, contentMode: UIViewContentMode = .scaleAspectFill) {
        imageView.contentMode = contentMode
        imageView.kf.setImage(with: url, placeholder: placeholder)
    }
}

//
//  InfiniteScrollView.swift
//  LesaraIosApp
//
//  Created by Ivan Solomichev on 10/12/16.
//  Copyright © 2016 Lesara. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class InfiniteScrollView: UIScrollView {
    private let scrollViewContentView = UIView()
    private var imagePathes: [String]?
    private var images: [UIImage]?
    private var isConfigured = false
    private lazy var selfWidth: CGFloat = {
        var result = CGRectGetWidth(self.bounds)
        return result
    }()
    private lazy var selfHeight: CGFloat = {
        var result = CGRectGetHeight(self.bounds)
        return result
    }()
    
    var selectedIndexHandler: ((idx: Int) -> ())?
    
    private var currentSelectedIndex: Int = 0
    
    func populate(images aImages: [UIImage]?) {
        imagePathes = nil
        images = aImages
        
        guard let images = images where images.count > 0 else {
            configNoImages()
            return
        }
        
        guard images.count > 1 else {
            populateSingleItem()
            return
        }
        
        populate()
    }

    func populate(imagePathes aImagePathes: [String]?) {
        images = nil
        imagePathes = aImagePathes
        
        guard let imagePathes = imagePathes where imagePathes.count > 0 else {
            configNoImages()
            return
        }
        
        guard imagePathes.count > 1 else {
            populateSingleItem()
            return
        }
        
        populate()
    }
    
    private func updateInitialOffset() {
        if itemCount() > 1 {
            self.setContentOffset(CGPoint(x: selfWidth * 2, y: 0), animated: false)
        }
    }
    
    private func itemCount() -> Int {
        var result = 0
        
        if let images = images {
            result = images.count
        } else if let imagePathes = imagePathes {
            result = imagePathes.count
        }
        
        return result
    }
    
    private func populate(imageView imgView: UIImageView, itemIndex: Int) {
        if let imagePathes = imagePathes {
            imgView.sd_setImageWithURL(NSURL(string: imagePathes[itemIndex]))
        } else if let images = images {
            imgView.image = images[itemIndex]
        }
    }
    
    private func populateSingleItem() {
        self.delegate = self
        self.addSubview(scrollViewContentView)
        
        scrollViewContentView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(self)
            make.width.equalTo(selfWidth)
            make.height.equalTo(selfHeight)
        })
        
        let imgView = UIImageView() //UIImageView(image: images.last!)
        imgView.contentMode = .ScaleAspectFit
        
        if let imagePathes = imagePathes {
            imgView.sd_setImageWithURL(NSURL(string: imagePathes.first!))
        } else {
            imgView.image = images?.first
        }
        
        scrollViewContentView.addSubview(imgView)
        
        imgView.snp_makeConstraints(closure: { (make) in
            make.edges.equalTo(scrollViewContentView)
        })
        
        updateInitialOffset()
    }
    
    private func populate() {
        self.delegate = self
        self.addSubview(scrollViewContentView)
        
        scrollViewContentView.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(self).multipliedBy(itemCount() + 2) //  in the begin and end
        }
        
        //  add last to beginning
        let imgViewLast = UIImageView()
        imgViewLast.contentMode = .ScaleAspectFit
        populate(imageView: imgViewLast, itemIndex: itemCount() - 1)
        
        scrollViewContentView.addSubview(imgViewLast)
        
        imgViewLast.snp_makeConstraints(closure: { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(selfWidth)
            make.height.equalTo(selfHeight)
        })
        
        //  add images
        for idx in 0..<itemCount() {
            let imgView = UIImageView()
            imgView.contentMode = .ScaleAspectFit
            populate(imageView: imgView, itemIndex: idx)
            
            scrollViewContentView.addSubview(imgView)
            
            imgView.snp_makeConstraints(closure: { (make) in
                make.width.equalTo(selfWidth)
                make.height.equalTo(selfHeight)
                make.top.bottom.equalTo(self)
                make.left.equalTo(CGFloat(scrollViewContentView.subviews.count - 1) * selfWidth)
            })
        }
        
        //  add first to end
        let imgViewFirst = UIImageView()
        imgViewFirst.contentMode = .ScaleAspectFit
        populate(imageView: imgViewFirst, itemIndex: 0)
        
        scrollViewContentView.addSubview(imgViewFirst)
        
        imgViewFirst.snp_makeConstraints(closure: { (make) in
            let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
            make.width.equalTo(screenWidth)
            make.height.equalTo(selfHeight)
            make.top.bottom.equalTo(self)
            make.left.equalTo(CGFloat(scrollViewContentView.subviews.count - 1) * screenWidth)
        })
        
        updateInitialOffset()
    }
    
    private func configNoImages() {
        self.snp_makeConstraints { (make) in
            make.width.equalTo(selfWidth)
            make.height.equalTo(selfHeight)
        }
        
        updateInitialOffset()
    }
}

extension InfiniteScrollView {
    func updateSelected(index: Int) {
        if imagePathes?.count > 1 {
            currentSelectedIndex = index + 1
        } else {
            currentSelectedIndex = index
        }
        
        self.setContentOffset(CGPoint(x: self.bounds.size.width * CGFloat(currentSelectedIndex), y: 0), animated: true)
    }
    
    private func updateOffsetCorrectly() {
        let offsetX = self.contentOffset.x
        
        if offsetX == 0 {
            self.setContentOffset(CGPoint(x: scrollViewContentView.bounds.size.width - CGFloat(self.bounds.size.width * 2), y: 0), animated: false)
        } else if offsetX == scrollViewContentView.bounds.size.width - self.bounds.size.width {
            self.setContentOffset(CGPoint(x: self.bounds.size.width, y: 0), animated: false)
        }
    }
}

extension InfiniteScrollView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        updateOffsetCorrectly()
        
        currentSelectedIndex = Int(self.contentOffset.x / selfWidth)
        selectedIndexHandler?(idx: currentSelectedIndex - 1)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        updateOffsetCorrectly()
    }
}

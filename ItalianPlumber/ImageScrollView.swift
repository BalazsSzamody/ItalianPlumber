//
//  ImageScrollView.swift
//  ItalianPlumber
//
//  Created by Balazs Szamody on 24/1/20.
//  Copyright © 2020 Balazs Szamody. All rights reserved.
//

import UIKit
import MSAutoView

protocol ImageScrollViewDelegate: AnyObject {
    func closeDidTap(on view: ImageScrollView)
}

class ImageScrollView: MSAutoView {
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var scrollViewLeading: NSLayoutConstraint!
    
    weak var delegate: ImageScrollViewDelegate?
    
    var image: UIImage? {
        didSet {
            updateView()
        }
    }
    
    func updateMinZoomScale() {
        setNeedsLayout()
        layoutIfNeeded()
        let size = bounds.size
        let imageSize = imageView.frame.size
        let widthScale = size.width / imageSize.width
        let heightScale = size.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrView.minimumZoomScale = minScale
        scrView.zoomScale = minScale
    }
    
    override func initView() {
        super.initView()
        scrView.delegate = self
//        updateMinZoomScale(for: self.bounds.size)
        addDoubleTapGesture()
    }
    
    override func updateView() {
        super.updateView()
        imageView.image = image
        updateMinZoomScale()
        updateScrollViewConstraints()
    }
    
    private func addDoubleTapGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(resetSize))
        doubleTap.numberOfTapsRequired = 2
        scrView.addGestureRecognizer(doubleTap)
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        delegate?.closeDidTap(on: self)
    }
    
    @objc private func resetSize() {
        UIView.animate(withDuration: 0.2) {
            self.scrView.zoomScale = self.scrView.minimumZoomScale
        }
    }
}

extension ImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollViewConstraints()
    }
    
    private func updateScrollViewConstraints() {
        setNeedsLayout()
        layoutIfNeeded()
        let viewSize = bounds.size
        let size = imageView.frame.size
        let xOffset = max(0, (viewSize.width - size.width) / 2)
        scrollViewLeading.constant = xOffset
        let yOffset = max(0, (viewSize.height - size.height) / 2)
        scrollViewTop.constant = yOffset
        setNeedsLayout()
        layoutIfNeeded()
    }
}

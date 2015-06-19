//
//  ImageViewController.swift
//  Cassini
//
//  Created by jeff greenberg on 6/17/15.
//  Copyright (c) 2015 Jeff Greenberg. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {

    // this MVC has a simple one-var model which is the image URL
    // so we just handle it here rather than in its own class
    var imageURL: NSURL? {
        didSet {
            image=nil
            if view.window != nil {
                fetchImage()    // only get the image if the view is on-screen
            }
        }
    }
    private func fetchImage() {
        if let url = imageURL {
            let imageData = NSData(contentsOfURL: url)  // don't ever do a slow op like this in the main thread!
            if imageData != nil {
                image = UIImage(data: imageData!)
            } else {
                image = nil
            }
        }
    }
    private var imageView = UIImageView()
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    private var image: UIImage? {
        get {return imageView.image}
        set {
            imageView.image=newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    // actually get the image data iff the view is going to be shown
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
}

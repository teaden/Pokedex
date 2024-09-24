//
//  ImageModalViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

import UIKit

class ImageModalViewController: UIViewController, UIScrollViewDelegate {

    weak var delegate: ImageModalDelegate?
    var image: UIImage?

    lazy private var imageView: UIImageView? = {
        return UIImageView.init(image: image)
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        let taplocation = sender.location(in: view)
        
        if !imageView!.frame.contains(taplocation) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let size = self.imageView?.image?.size {
            self.scrollView.addSubview(self.imageView!)
            self.scrollView.contentSize = size
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 3.0
            self.scrollView.delegate = self
        }
             
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isBeingDismissed {
            self.delegate?.dismissModal()
        }
    }
}

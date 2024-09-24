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

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        let taplocation = sender.location(in: view)
        
        if !imageView.frame.contains(taplocation) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
        scrollView.delegate = self

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
        
        scrollView.contentSize = imageView.bounds.size
             
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

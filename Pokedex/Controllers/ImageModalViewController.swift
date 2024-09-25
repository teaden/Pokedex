//
//  ImageModalViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

import UIKit

/// Controls a UIView with an ImageView and ScrollView that pushes modally onto PokemonView
class ImageModalViewController: UIViewController, UIScrollViewDelegate {
    
    /// PokemonViewController instantiates ImageModalViewController and sets below two properties
    weak var delegate: ImageModalDelegate?
    var image: UIImage?
    
    /// Lazily instantiate an imageView that will display Pokemon image
    lazy private var imageView: UIImageView? = {
        return UIImageView.init(image: image)
    }()
    
    /// Allow for zooming in and out as well as scrolling over the Pokemon image
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// Dismisses the modal is the user taps in an area outside of the space occupied by the Pokemon image
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        let taplocation = sender.location(in: view)
        
        if !imageView!.frame.contains(taplocation) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Programatically configue the Pokemon image embedded in ScrollView, ScrollView size, zoom limits
        if let size = self.imageView?.image?.size {
            self.scrollView.addSubview(self.imageView!)
            self.scrollView.contentSize = size
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 3.0
            self.scrollView.delegate = self
        }
        
        /// Add the handleTap gesture reco
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    /// UIScrollViewDelegate method allows for zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /// Ensures timer that swaps between images on PokemonView restarts upon modal dismissal
        if self.isBeingDismissed {
            self.delegate?.dismissModal()
        }
    }
}

//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

import UIKit
import AVFAudio

class PokemonViewController: UIViewController, ImageModalDelegate {

    var pokemonIndex: Int?
    
    var pokemon: SinglePokemonModel?
    var artwork: [UIImage] = []
    var sound: AVAudioPlayer?
    
    var timer: Timer?
    var currentImageIndex = 0

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBAction func tapPlayButton(_ sender: UIButton) {
        sound?.play()
    }
    
    @IBAction func changeVolumeSlider(_ sender: UISlider) {
        sound?.volume = sender.value
    }
    
    @IBAction func tapImageView(_ sender: UITapGestureRecognizer) {

        if let imageModalVC = storyboard?.instantiateViewController(withIdentifier: "ImageModalViewController") as? ImageModalViewController {
            
            imageModalVC.delegate = self
            imageModalVC.image = imageView.image
            present(imageModalVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = pokemonIndex {
            pokemon = try? PokemonModel.getPokemonByIndex(index: index)
            artwork = (try? PokemonModel.getAllArtworkByIndex(index: index)) ?? []
            sound = try? PokemonModel.getAudioByIndex(index: index)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_:)))
    
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.image = artwork.first
        
        self.setupAudioPlayer()
        self.startImageCycling()
    }
    
    func dismissModal() {
        self.startImageCycling()
    }
        
    func startImageCycling() {
        stopImageCycling()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.animateImageTransition()
        }
    }
    
    func stopImageCycling() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func animateImageTransition() {

        // Toggle between the two images
        self.currentImageIndex = (self.currentImageIndex + 1) % self.artwork.count

        UIView.transition(
            with: imageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
                          animations: {
                              self.imageView.image = self.artwork[self.currentImageIndex]
                          }, completion: nil)
    }
    
    private func setupAudioPlayer() {
  
        sound?.volume = volumeSlider.value
        
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        volumeSlider.value = sound?.volume ?? 0.5
    }
}

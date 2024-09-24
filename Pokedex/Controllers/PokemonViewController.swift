//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

import UIKit
import AVFAudio

class PokemonViewController: UIViewController {
    
    var pokemonIndex: Int?
    
    lazy var currentImageIndex = 0
    
    lazy var pokemon: SinglePokemonModel = {
        guard let index = pokemonIndex, let result = try? PokemonModel.getPokemonByIndex(index: index) else {
            fatalError("PokemonViewController: Could not retrieve pokemon by index")
        }
        return result
    }()

    lazy var artwork: [UIImage] = {
        guard let index = pokemonIndex, let result = try? PokemonModel.getAllArtworkByIndex(index: index) else {
            fatalError("PokemonViewController: Could not retrieve image by index")
        }
        return result
    }()

    lazy var sound: AVAudioPlayer = {
        guard let index = pokemonIndex, let result = try? PokemonModel.getAudioByIndex(index: index) else {
            fatalError("PokemonViewController: Could not retrieve audoi by index")
        }
        return result
    }()
    
    lazy var timer: Timer = {
        return Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.animateImageTransition()
        }
    }()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBAction func tapPlayButton(_ sender: UIButton) {
        sound.play()
    }
    
    @IBAction func changeVolumeSlider(_ sender: UISlider) {
        sound.volume = sender.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = artwork[0]
        self.setupAudioPlayer()
        
        // Start the timer
        startImageCycling()
    }
    
    private func setupAudioPlayer() {
  
        sound.volume = volumeSlider.value
        
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        volumeSlider.value = sound.volume
    }
    
    func startImageCycling() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in // Adjust interval as needed
            self?.animateImageTransition()
        }
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
}

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
    
    lazy var pokemon: SinglePokemonModel = {
        guard let index = pokemonIndex, let result = try? PokemonModel.getPokemonByIndex(index: index) else {
            fatalError("PokemonViewController: Could not retrieve pokemon by index")
        }
        return result
    }()

    lazy var artwork: UIImage = {
        guard let index = pokemonIndex, let result = try? PokemonModel.getArtworkByIndex(index: index) else {
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
        imageView.image = artwork
        self.setupAudioPlayer()
    }
    
    private func setupAudioPlayer() {
  
        sound.volume = volumeSlider.value
        
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        volumeSlider.value = sound.volume
    }
}

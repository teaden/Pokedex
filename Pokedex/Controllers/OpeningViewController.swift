//
//  OpeningViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/21/24.
//

import UIKit
import AVFAudio

class OpeningViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var selectedPokemonGen: PokemonGens?
    lazy var pokemonModel = PokemonModel.shared
    
    lazy var audioPlayer: AVAudioPlayer? = {
        do {
            return try AssetModel.serveAudioPlayer(fileName: "PokeIntro", extensionType: "mp3")
        } catch {
            print("Error creating audio player: \(error)")
            return nil
        }
    }()
    
    lazy var loadingView: UIView = {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = overlay.center
        activityIndicator.startAnimating()
        
        overlay.addSubview(activityIndicator)
        
        return overlay
    }()
    

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var genPickerView: UIPickerView!
    @IBOutlet weak var viewPokemonButton: UIButton!
    
    @IBAction func sendChosenGen(_ sender: UIButton) {
        let selectedGen = selectedPokemonGen!

        sender.isEnabled = false
        transitionToLoadingView()

        Task {
            do {
                try await PokemonModel.setup(with: selectedGen.rawValue)

                await MainActor.run {
                    transitionBackFromLoadingView()
                    displaySuccessMessage()
                    viewPokemonButton.isHidden = false
                    sender.isEnabled = true
                }
            } catch {
                await MainActor.run {
                    transitionBackFromLoadingView()
                    displayErrorMessage(error)
                    sender.isEnabled = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genPickerView.dataSource = self
        genPickerView.delegate = self
        genPickerView.selectRow(0, inComponent: 0, animated: false)
        selectedPokemonGen = PokemonGens.allCases[0]
        
        try! updateImageView(logoImageView, with: "logo.png")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.audioPlayer?.play()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PokemonGens.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PokemonGens.allCases[row].displayName

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPokemonGen = PokemonGens.allCases[row]
    }
    
    func updateImageView(_ imageView: UIImageView?, with imageName: String) throws {
        guard let imageView = imageView else {
            throw ResourceError.imageViewUnavailable
        }
        imageView.image = try AssetModel.serveImage(fileName: imageName)
    }
    
    func transitionToLoadingView() {
        view.addSubview(loadingView)
    }
    
    func transitionBackFromLoadingView() {
        loadingView.removeFromSuperview()
    }
    
    func displaySuccessMessage() {
        let alert = UIAlertController(title: "Success", message: "The Pokémon data has been loaded successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func displayErrorMessage(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
  
        present(alert, animated: true, completion: nil)
    }
}


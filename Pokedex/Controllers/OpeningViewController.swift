//
//  OpeningViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/21/24.
//

import UIKit
import AVFAudio

/// Controls the first UIView that users see after launching the app
class OpeningViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    /// Represents option via custom enum currently selected in the picker
    var selectedPokemonGen: PokemonGens?
    
    /// Lazily load singleton class model PokemonModel
    lazy var pokemonModel = PokemonModel.shared
    
    /// Lazily load audio player for "PokeIntro.mp3" included in Data subfolder
    lazy var audioPlayer: AVAudioPlayer? = {
        do {
            return try AssetModel.serveAudioPlayer(fileName: "PokeIntro", extensionType: "mp3")
        } catch {
            print("Error creating audio player: \(error)")
            return nil
        }
    }()
    
    /// Lazily loads "loading" UIView with activity indicator when loading Pokemon records from JSON on backend
    lazy var loadingView: UIView = {
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = overlay.center
        activityIndicator.startAnimating()
        
        overlay.addSubview(activityIndicator)
        
        return overlay
    }()
    
    /// Outlet to the UIImageView that has a "title" image or logo
    @IBOutlet weak var logoImageView: UIImageView!
    
    /// Outlet to the picker used for selecting a Pokemon generation (i.e., indicating which JSON file to load from backend)
    @IBOutlet weak var genPickerView: UIPickerView!
    
    /// Outlet to the "View Pokemon" button that appears on UIView after Pokemon data loaded from JSON on the backend
    @IBOutlet weak var viewPokemonButton: UIButton!
    
    /// Sends selected picker item (PokemonGeneration enum specifying JSON file name) to backend for data loading
    @IBAction func sendChosenGen(_ sender: UIButton) {
        /// Assigns Pokemon generation chosen in picker as the currently selected option
        let selectedGen = selectedPokemonGen!
        
        /// Ensures repeated calls to backend cannot happen until onec all finishes
        sender.isEnabled = false
        transitionToLoadingView()
        
        /// Loads Pokemon JSON data in unstructured concurrent fashion from backend based on generation selected in picker
        Task {
            do {
                /// Sets up wth singleton class model PokemonModel with records from backend, fetches images and audio
                try await PokemonModel.setup(with: selectedGen.rawValue)
                
                /// Ensures UIView upates of moving to loading view and alerting data loading success are handled on main thread
                await MainActor.run {
                    transitionBackFromLoadingView()
                    displaySuccessMessage()
                    viewPokemonButton.isHidden = false
                    sender.isEnabled = true
                }
            } catch {
                
                /// Ensures UIView upates of moving to loading view and alerting data loading failure  are handled on main thread
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
        
        /// Assigns picker delegate and data source to this class instance
        genPickerView.dataSource = self
        genPickerView.delegate = self
        
        /// Makes first Pokemon generation the default option chosen by picker and selected by this class instance
        genPickerView.selectRow(0, inComponent: 0, animated: false)
        selectedPokemonGen = PokemonGens.allCases[0]
        
        /// Load the logo image "logo.png" from assets into ImageView
        try! updateImageView(logoImageView, with: "logo.png")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Makes sure intro audio theme only starts playing when user sees the UIView
        self.audioPlayer?.play()
    }
    
    /// Set only one column in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Set number of picker rows equivalent to the number of PokemonGens enum cases (which specify name of JSON file with Pokemon data)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return PokemonGens.allCases.count
    }
    
    /// Sets picker row text to computed enum property display name that has appropriate spacing for UI viewing compared to raw value
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return PokemonGens.allCases[row].displayName

    }
    
    /// Updates state with the Pokemon generation case chosen by picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPokemonGen = PokemonGens.allCases[row]
    }
    
    /// Helper function for loading images from assets into logoImageView outlet
    func updateImageView(_ imageView: UIImageView?, with imageName: String) throws {
        guard let imageView = imageView else {
            throw ResourceError.imageViewUnavailable
        }
        imageView.image = try AssetModel.serveImage(fileName: imageName)
    }
    
    /// Helper function that adds loading view with activity indicator to view while Pokemon data fetched from backend
    func transitionToLoadingView() {
        view.addSubview(loadingView)
    }
    
    /// Helper function that removes the loading view with activity indicator after Pokemon data fetching from backend is complete
    func transitionBackFromLoadingView() {
        loadingView.removeFromSuperview()
    }
    
    /// Helper function that shows success message if no error with Pokemon data fetching from backend
    func displaySuccessMessage() {
        let alert = UIAlertController(title: "Success", message: "The Pokémon data has been loaded successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    /// Helper function that shows error message if no error with Pokemon data fetching from backend
    func displayErrorMessage(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
  
        present(alert, animated: true, completion: nil)
    }
}


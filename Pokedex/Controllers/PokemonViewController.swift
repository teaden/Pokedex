//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

import UIKit
import AVFAudio

/// A "get by id" or single record type of UIView for one Pokemon record
/// Interacts with singleton Pokemon model via class methods and therefore does not instantiate shared reference
/// "ImageModalDelegate" is custom protocol utilized for handling modal view that objects of this class can instantiate
class PokemonViewController: UIViewController, ImageModalDelegate {
    /**
     Note: The below properties are not lazily instantiated for the following reason. is a longer documentation note in Swift.
     Images swap based on a timer, and the timer starts based on the loading of the other properties.
     Lazy loading might therefore causes the image swap functionalty to be slightly delayed upon initial view load.
     Eager loading was preferred in this case to avoid the above scenario
     The timer is also cycled between "on" and "off" (i.e., nil) based on conditions, so lazy loading the timer was less applicaable
     */
    
    /// Index to single Pokemon item in singleton PokemonModel pokemonRecords
    /// Index provided via segue from TableViewcontroller and CollectionsViewController
    var pokemonIndex: Int?
    
    /// Single Pokemon item in singleton PokemonModel pokemonRecords
    var pokemon: SinglePokemonModel?
    
    /// Various artwork images tied to the above single Pokemon item property "pokemon"
    var artwork: [UIImage] = []
    
    /// A sound or battle cry tied to the above single Pokemon item property "pokemon"
    var sound: AVAudioPlayer?
    
    /// A timer that is used in conjunction with animations to automatically swap between artwork images
    var timer: Timer?
    
    /// The index of the current image in view (i.e., the current image after swap) from the "artwork" array property
    var currentImageIndex = 0
    
    /// Outlet that displays the currently active or selected Pokemon image from the "artwork" property
    @IBOutlet weak var imageView: UIImageView!
    
    /// Outlet to play button that plays Pokemon sound or battle cry
    @IBOutlet weak var playButton: UIButton!
    
    /// Outlet to slider the controls the volume of the above sound or battle cry
    @IBOutlet weak var volumeSlider: UISlider!
    
    /// Handler that plays the Pokmeon sound or battle cry upon tapping the "Play" button
    @IBAction func tapPlayButton(_ sender: UIButton) {
        sound?.play()
    }
    
    /// Handler that adjusts volume of Pokemon battle cry based on slider value changes
    @IBAction func changeVolumeSlider(_ sender: UISlider) {
        sound?.volume = sender.value
    }
    
    /// Handler that upon tapping currently active Pokemon artwork image leads to modal view, i.e., an isolated, larger view of that image
    @IBAction func tapImageView(_ sender: UITapGestureRecognizer) {

        if let imageModalVC = storyboard?.instantiateViewController(withIdentifier: "ImageModalViewController") as? ImageModalViewController {
            
            imageModalVC.delegate = self
            imageModalVC.image = imageView.image
            
            /// Stop the timer to pause image cycling when the modal is up
            stopImageCycling()
            
            present(imageModalVC, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Pull pokemon record, artwork images, and sound using singleton class PokemonModel class methods and currentIndex
        /// Property currentIndex is supplied via segues by TableViewController and CollectionViewController
        if let index = pokemonIndex {
            pokemon = try? PokemonModel.getPokemonByIndex(index: index)
            artwork = (try? PokemonModel.getAllArtworkByIndex(index: index)) ?? []
            sound = try? PokemonModel.getAudioByIndex(index: index)
        }
        
        /// Make tap gesture that utilizes tapImageView handler
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapImageView(_:)))
        
        /// Add tapImageView tap gesture to Pokemon artwork ImageView and allow user interactivity
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        /// Initialize artwork ImageView to hold the first image in the artwork array
        imageView.image = artwork.first
        
        self.setupAudioPlayer()     /// Ensure battle cry volume is linked to slider values
        self.startImageCycling()    /// Begin timer that triggers artwork
    }
    
    /// ImageModalDelegate function that handles activation of the timer that triggers the artwork image swap animation
    func dismissModal() {
        self.startImageCycling()
    }
    
    /// Function for the activation of the timer that triggers the artwork image swap animation
    func startImageCycling() {
        /// Ensure that two times are not not accidentally created (i.e., when existing from the modal view)
        if (self.timer == nil) {
            /// Creates timer that triggers animation to swap artwork image after 2 seconds
            /// Weak reference to self is captured in case timer outlives this ViewController
            /// However, the timer is stopped in deinit, so weak self is just a good practice even if not needed here
            self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
                self?.animateImageTransition()
            }
        }
    }
    
    /// Removes timer from RunLoop and updates state to reflect lack of active timer
    func stopImageCycling() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /// Function that is called repeatedly via the Timer object to swap artwork images assigned to the imageView
    func animateImageTransition() {

        /// Increments index of image in artwork array to swap to by 1
        /// Ensures looping back to first image in artwork array if currently at last image
        self.currentImageIndex = (self.currentImageIndex + 1) % self.artwork.count
        
        /// UIView transition with animation that cross dissolves to the next image in the artwork array
        UIView.transition(
            with: imageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
                          animations: {
                              self.imageView.image = self.artwork[self.currentImageIndex]
                          }, completion: nil)
    }
    
    /// Links Pokemon sound or battle cry volume to the volume slider values
    private func setupAudioPlayer() {

        /// Make default battle cry volume the default value of the volume slider
        sound?.volume = volumeSlider.value
        
        /// Set the minimum and maximum values of the volume slider
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
    }
    
    /// Make sure that Timer objects do not outlive the PokemonView
    deinit {
        stopImageCycling()
    }
}

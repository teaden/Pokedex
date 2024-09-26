//
//  CollectionViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit

private let reuseIdentifier = "CollectCell"

class CollectionViewController: UICollectionViewController {
    
    /// Lazily load singleton class model PokemonModel
    lazy var pokemonModel = PokemonModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource
    
    /// Load only 1 section in the CollvectionView
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// Ensure number of items or cells is equivalent to the number of pokemon records found in singleton model
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemonModel.pokemonRecords!.pokemon.count
    }
    
    /// Dequeue and configure cell based on reuseIdentifier defined at top of file above class definition
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /// Attempt to cast dequeued UICollectionViewCell cell into custom subclass CollectionViewCell object that has a UIIMageView
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell {
            
            /// Set border line boldness andd color as well as ImageView based on indexing into singleton PokemonModel artwork
            cell.imageView.layer.borderWidth = 2.0
            cell.imageView.layer.borderColor = UIColor.gray.cgColor
            cell.imageView.image = try! PokemonModel.getArtworkByIndex(index: indexPath.row)
            
            return cell
            
        } else {
            /// Consider throwing a custom error and handling the inability to dequeue with an appropriate UI update
            fatalError("Could not dequeue cell")
        }
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonDetails",
           let pokemonVC = segue.destination as? PokemonViewController,
           let indexPath = collectionView.indexPathsForSelectedItems?.first {
            pokemonVC.pokemonIndex = indexPath.row
        }
    }
}

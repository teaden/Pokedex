//
//  CollectionViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit

private let reuseIdentifier = "CollectCell"

class CollectionViewController: UICollectionViewController {
    
    lazy var pokemonModel = PokemonModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumInteritemSpacing = 4 // Adjust as needed
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemonModel.pokemonRecords!.pokemon.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollectionViewCell {
            
            cell.imageView.layer.borderWidth = 2.0
            cell.imageView.layer.borderColor = UIColor.gray.cgColor
            cell.imageView.image = try! PokemonModel.getArtworkByIndex(index: indexPath.row)
            
            return cell
            
        } else {
            fatalError("CollectionViewController: Could not dequeue cell")
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

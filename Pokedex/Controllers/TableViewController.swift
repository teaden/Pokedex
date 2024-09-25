//
//  TableViewController.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/23/24.
//

import UIKit

class TableViewController: UITableViewController {
    
    lazy var pokemonModel = PokemonModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    /// Load only 1 section in the TableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Lazily load singleton class model PokemonModel
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemonModel.pokemonRecords!.pokemon.count
    }

    /**
     The below functionality dequeues cells based on four dynamic prototypes.
     Cases for handling which cell to dequeue are specified by cellType enum on SinglePokemonModel record
        1. reuseIdentifier: TypeOneId - Pokemon has 1 type (e.g., fire) and has no held item (e.g., Lum Berry)
        2. reuseIdentifier: TypeTwoId - Pokemon has 1 type and has a held item
        3. reuseIdentifier: TypeThreeId - Pokemon has 2+ types and has no held item
        4. reuseIdentifier: TypeFourId - Pokemon has 2+ types and has a held item
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = self.pokemonModel.pokemonRecords!.pokemon[indexPath.row]
        
        // All dynamic prototype cells have ImageView, "main" label, and "details" label UI elements
        switch pokemon.cellType {
        case .oneTypeNoHeldItem:
            // Pokemon has 1 type (i.e., fire) and has no held item (i.e., Lum Berry)
            // Standard cell with ImageView, "main" label, and "details" label UI elements
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeOneId", for: indexPath) as! TableViewCellOne
            cell.configure(with: pokemon)
            return cell
        case .oneTypeHeldItem:
            // Pokemon has 1 type and has a held item
            // Has Switch that swaps "details" label text between type info and held item info
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeTwoId", for: indexPath) as! TableViewCellTwo
            cell.configure(with: pokemon)
            return cell
        case .multipleTypesNoHeldItem:
            // Pokemon has 2+ types and has no held item
            // Has Stepper that increments the number of types concatenated in the "details" label text
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeThreeId", for: indexPath) as! TableViewCellThree
            cell.configure(with: pokemon)
            return cell
        case .multipleTypesHeldItem:
            // Pokemon has 2+ types and has a held item
            // Has Switch that swaps "details" label text between type info and held item info
            // Has Stepper that increments the number of types concatenated in the "details" label text
            // Stepper hides when Switch is on, i.e., when "details" label has held item info instead of type info
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeFourId", for: indexPath) as! TableViewCellFour
            cell.configure(with: pokemon)
            return cell
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonDetails",
           let pokemonVC = segue.destination as? PokemonViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            pokemonVC.pokemonIndex = indexPath.row
        }
    }
}

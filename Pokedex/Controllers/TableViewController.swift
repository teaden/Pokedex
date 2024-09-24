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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemonModel.pokemonRecords!.pokemon.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon = self.pokemonModel.pokemonRecords!.pokemon[indexPath.row]
        
        switch pokemon.cellType {
        case .oneTypeNoHeldItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeOneId", for: indexPath) as! TableViewCellOne
            cell.configure(with: pokemon)
            return cell
        case .oneTypeHeldItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeTwoId", for: indexPath) as! TableViewCellTwo
            cell.configure(with: pokemon)
            return cell
        case .multipleTypesNoHeldItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeThreeId", for: indexPath) as! TableViewCellThree
            cell.configure(with: pokemon)
            return cell
        case .multipleTypesHeldItem:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypeFourId", for: indexPath) as! TableViewCellFour
            cell.configure(with: pokemon)
            return cell
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonDetails",
           let pokemonVC = segue.destination as? PokemonViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            pokemonVC.pokemonIndex = indexPath.row
        }
    }
}

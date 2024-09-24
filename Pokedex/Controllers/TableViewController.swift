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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ImageModalDelegate.swift
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

import Foundation
import UIKit

/// Custom protocol used by PokemonViewController for handling ImageModalViewController
protocol ImageModalDelegate: UIViewController {
    func dismissModal()
}

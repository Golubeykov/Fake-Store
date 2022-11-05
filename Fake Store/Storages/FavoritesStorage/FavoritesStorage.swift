//
//  FavoritesStorage.swift
//  Fake Store
//
//  Created by Антон Голубейков on 05.11.2022.
//

import Foundation

final class FavoritesStorage {

    //MARK: Public properties

    static let shared = FavoritesStorage()
    var myFavorites = [String]()
    private let keyForFavoritesStorage = "favoriteItems"

    //MARK: - Private property

    private let defaults = UserDefaults.standard

    private init() {
        let favorites = defaults.stringArray(forKey: keyForFavoritesStorage) ?? [String]()
        for favorite in favorites {
            addFavorite(favoriteItem: favorite)
        }
    }
    //MARK: - Public methods

    func isItemFavorite(item: String) -> Bool {
        if myFavorites.contains(item) {
            return true
        } else {
         return false
        }
    }

    func addFavorite(favoriteItem: String) {
        if !myFavorites.contains(where: { $0 == favoriteItem }) {
            myFavorites.append(favoriteItem)
        }
        defaults.set(myFavorites, forKey: keyForFavoritesStorage)
        ProductsViewController.favoriteTapStatus = true
        FavoritesViewController.favoriteTapStatus = true
    }

    func removeFavorite(favoriteItem: String) {
        guard let index = myFavorites.firstIndex(of: favoriteItem) else { return }
        myFavorites.remove(at: index)
        defaults.set(myFavorites, forKey: keyForFavoritesStorage)
        ProductsViewController.favoriteTapStatus = true
        FavoritesViewController.favoriteTapStatus = true
    }
    
}

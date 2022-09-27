//
//  TabBarModel.swift
//  Fake Store
//
//  Created by Антон Голубейков on 27.09.2022.
//

import UIKit

private enum TabBarImages {
    static let catalogTabImage: UIImage? = ImagesStorage.catalogTabBarImage
    static let favoritesTabImage: UIImage? = ImagesStorage.favoritesTabBarImage
    static let cartTabImage: UIImage? = ImagesStorage.cartTabBarImage
    static let profileTabImage: UIImage? = ImagesStorage.profileTabBarImage
}

enum TabBarModel {
    case catalog
    case favorites
    case cart
    case profile

    var title: String {
        switch self {
        case .catalog:
            return "Каталог"
        case .favorites:
            return "Избранное"
        case .cart:
            return "Корзина"
        case .profile:
            return "Профиль"
        }
    }
    var image: UIImage? {
        switch self {
        case .catalog:
            return TabBarImages.catalogTabImage
        case .favorites:
            return TabBarImages.favoritesTabImage
        case .cart:
            return TabBarImages.cartTabImage
        case .profile:
            return TabBarImages.profileTabImage
        }
    }
    
    var selectedImage: UIImage? {
        return image
    }
}

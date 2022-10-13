//
//  NetworkMethod.swift
//  Fake Store
//
//  Created by Антон Голубейков on 13.10.2022.
//

import Foundation

enum NetworkMethod: String {

     case get
     case post

 }

 extension NetworkMethod {

     var method: String {
         rawValue.uppercased()
     }

 }

//
//  Pokemon.swift
//  PokemonLibraryTestTask
//
//  Created by Denis on 16.01.2021.
//

import UIKit

struct Pokemon: Decodable {
  var name: String
  let url: URL
  let imageURL: URL?
  
  enum CodingKeys: String, CodingKey {
    case name
    case url
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try values.decode(String.self, forKey: .name)
    self.url = try values.decode(URL.self, forKey: .url)
    
    if let pokemonId = url.absoluteString.split(separator: "/").last {
      let string = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonId).png"
      self.imageURL = URL(string: string)
    } else {
      self.imageURL = nil
    }
    
    if let replacedName = name.replacingOccurrences(of: "-", with: " ", options: .literal, range: nil) as? String {
      self.name = replacedName
    }
  }
}

struct PokemonList: Decodable {
  let results: [Pokemon]
}

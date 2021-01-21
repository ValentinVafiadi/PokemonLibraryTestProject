//
//  TableViewController.swift
//  PokemonLibraryTestTask
//
//  Created by Denis on 13.01.2021.
//

import UIKit
import SwiftGifOrigin

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  let loadingGif = UIImage.gif(name: "loading")
  var url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=30&offset=0")!
  let pokemonTableView = UITableView()
  let pokemonCell = "PokemonCell"
  var pokemonList = [Pokemon]()
  var fetchingMore = false
  var counter = 30
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pokemonTableView)
        self.navigationItem.title = "Pokemons";
      
        pokemonTableView.register(UITableViewCell.self, forCellReuseIdentifier: pokemonCell)
        pokemonTableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.loadingCell)
      
        pokemonTableView.delegate = self
        pokemonTableView.dataSource = self
      
        pokemonTableView.translatesAutoresizingMaskIntoConstraints = false
        pokemonTableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        pokemonTableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        pokemonTableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        pokemonTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        pokemonTableView.tableFooterView = UIView() // hid empty cells
        downloadJson()
    }

  func downloadJson() {
    URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
      guard let data = data, response != nil, error == nil else {
        print("ooops")
        return
      }
      let decoder = JSONDecoder()
      let pokemonList = try? decoder.decode(PokemonList.self, from: data)
      guard let downloadedPokemonList = pokemonList else {
        return
      }
      self?.pokemonList = downloadedPokemonList.results
      DispatchQueue.main.async {
        self?.pokemonTableView.reloadData()
      }
    }).resume()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let vc = ViewController()
    var currentSelectedImage: URL!
    var currentSelectedLabel: String!
    currentSelectedImage = pokemonList[indexPath.row].imageURL
    currentSelectedLabel = pokemonList[indexPath.row].name.capitalized
    vc.setImageName(image: currentSelectedImage)
    vc.setLabelName(name: currentSelectedLabel)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
     return 2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return pokemonList.count
    } else if section == 1 && fetchingMore {
      return 1
    }
    return 0
 }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: pokemonCell, for: indexPath)
      cell.accessoryType = .disclosureIndicator
      cell.textLabel?.text = pokemonList[indexPath.row].name.capitalized
      cell.imageView?.kf.setImage(with: pokemonList[indexPath.row].imageURL, placeholder: loadingGif)
     return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: LoadingCell.loadingCell, for: indexPath) as! LoadingCell
      cell.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0) // hid separator line
      cell.loadingIndicator.startAnimating()
     return cell
    }
 }
    
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    if offsetY > contentHeight - scrollView.frame.height {
      if !fetchingMore {
        beginBatchFeatch()
        self.counter += 30
      }
    }
  }
  
  func beginBatchFeatch() {
    fetchingMore = true
    pokemonTableView.reloadSections(IndexSet(integer: 1), with: .none)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
      let newPokemonsURL = "https://pokeapi.co/api/v2/pokemon?limit=\(self.counter)&offset=0"
      print(newPokemonsURL)
      self.url = URL(string: newPokemonsURL)!
      self.downloadJson()
      self.fetchingMore = false
      self.pokemonTableView.reloadData()
    })
  }
}

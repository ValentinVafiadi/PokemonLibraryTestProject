//
//  LoadingCell.swift
//  PokemonLibraryTestTask
//
//  Created by Denis on 19.01.2021.
//

import UIKit

class LoadingCell: UITableViewCell {

  static let loadingCell = "LoadingCell"
  let loadingIndicator = UIActivityIndicatorView()
  
    override func awakeFromNib() {
      super.awakeFromNib()
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(loadingIndicator)
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

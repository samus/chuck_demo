//
//  FavoriteCollectionViewCell.swift
//  ORSampleSCorder
//
//  Created by Sam Corder on 8/2/18.
//  Copyright © 2018 Synapptic Labs. All rights reserved.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var jokeLbl: UILabel!

    var viewModel: FavoriteCellViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            jokeLbl.text = vm.text
        }
    }

    override func prepareForReuse() {
        jokeLbl.text = nil
        viewModel = nil
    }
}

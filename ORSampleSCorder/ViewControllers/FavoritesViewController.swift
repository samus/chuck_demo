//
//  FavoritesViewController.swift
//  ORSampleSCorder
//
//  Created by Sam Corder on 8/2/18.
//  Copyright © 2018 Synapptic Labs. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class FavoritesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    
    var viewModel: FavoritesViewModel?
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let vm = FavoritesViewModel()
        viewModel = vm
        vm.rows.bind(to: collectionView.rx.items(cellIdentifier: "jokecell", cellType: FavoriteCollectionViewCell.self))  { _, model, cell in
            cell.jokeLbl.text = model.text
        }.disposed(by: disposeBag)

        collectionViewLayout.estimatedItemSize = CGSize(width: 1, height: 1)
    }
}

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

class FavoritesViewController: UIViewController, UICollectionViewDragDelegate {
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

        sizeLayout(size: self.view.frame.size)

        collectionView.dragDelegate = self
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.sizeLayout(size: size)
        }, completion: nil)
    }

    func sizeLayout(size: CGSize) {
        let contentWidth = size.width - (collectionViewLayout.sectionInset.left - collectionViewLayout.sectionInset.right)
        let preferredWidth = contentWidth >= 300 ? 300 : contentWidth
        collectionViewLayout.itemSize = CGSize(width: preferredWidth, height: 300)
        let itemsPerRow = (size.width - size.width.truncatingRemainder(dividingBy: preferredWidth)) / preferredWidth
        let spacing = (size.width - (itemsPerRow * preferredWidth)) / (2 + (itemsPerRow - 1))

        collectionViewLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        collectionViewLayout.minimumInteritemSpacing = spacing - itemsPerRow
        collectionViewLayout.minimumLineSpacing = spacing
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FavoriteCollectionViewCell else { return [] }
        guard let text = cell.jokeLbl.text else { return [] }
        let provider = NSItemProvider(object: text as NSString)
        return [UIDragItem(itemProvider: provider)]
    }
}

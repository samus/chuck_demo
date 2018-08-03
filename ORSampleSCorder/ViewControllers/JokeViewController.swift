//
//  ViewController.swift
//  ORSampleSCorder
//
//  Created by Sam Corder on 8/1/18.
//  Copyright © 2018 Synapptic Labs. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class JokeViewController: UIViewController {
    @IBOutlet weak var jokeLbl: UILabel!
    @IBOutlet weak var nextJokeBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var listFavoritesBtn: UIBarButtonItem!

    var viewModel: JokeViewModel? = nil

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let inputs: JokeViewModelInputs = (chuck: nextJokeBtn.rx.tap, favorite: favoriteBtn.rx.tap)
        let vm = JokeViewModel(inputs: inputs)

        vm.jokeText.bind(to: jokeLbl.rx.text).disposed(by: disposeBag)

        vm.saveResults.subscribe(onNext: { _ in
            //Display error message
        }).disposed(by: disposeBag)

        listFavoritesBtn.rx.tap.debug().subscribe(onNext: {[weak self] _ in
            self?.performSegue(withIdentifier: "favorites", sender: self)
        }).disposed(by: disposeBag)

        viewModel = vm

        nextJokeBtn.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }

    override func viewDidLayoutSubviews() {
        nextJokeBtn.layer.cornerRadius = nextJokeBtn.frame.width / 2.0
        favoriteBtn.layer.cornerRadius = favoriteBtn.frame.width / 2.0
    }
}


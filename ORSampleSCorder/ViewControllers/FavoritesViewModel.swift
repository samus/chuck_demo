//
//  FavoritesViewModel.swift
//  ORSampleSCorder
//
//  Created by Sam Corder on 8/2/18.
//  Copyright © 2018 Synapptic Labs. All rights reserved.
//

import Foundation

import RxSwift

class FavoritesViewModel {
    let repo = JokeRepository()
    let rows: Observable<[FavoriteCellViewModel]>

    init() {
        let repo = self.repo
        rows = repo.readFavorites().map {jokes -> [FavoriteCellViewModel] in
            return jokes.map { FavoriteCellViewModel(joke: $0) }
        }
    }
}

class FavoriteCellViewModel {
    fileprivate let joke: Joke

    let text: String

    init(joke: Joke) {
        self.joke = joke
        self.text = joke.text
    }
}

//
//  JokeViewModel.swift
//  ORSampleSCorder
//
//  Created by Sam Corder on 8/1/18.
//  Copyright © 2018 Synapptic Labs. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

typealias JokeViewModelInputs = (chuck: ControlEvent<Void>, favorite: ControlEvent<Void>)

class JokeViewModel {
    let jokeText: Observable<String>
    let saveResults: Observable<Bool>

    init(inputs: JokeViewModelInputs) {
        let apiClient = JokeApiClient()
        let jokes = inputs.chuck.startWith(()).flatMap { _ in
                return apiClient.random()
            }.filter { $0.joke != nil }
            .map { $0.joke! }
            .share(replay: 1, scope: SubjectLifetimeScope.whileConnected)

        jokeText = jokes.map { $0.text }

        let repo = JokeRepository()
        saveResults = inputs.favorite.withLatestFrom(jokes).flatMap { (joke) -> Observable<Bool> in
            return repo.saveFavorite(joke: joke)
        }
    }
}

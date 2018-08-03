//
//  JokeRepository.swift
//  ORSampleSCorder
//
//  Created by Sam Corder on 8/1/18.
//  Copyright © 2018 Synapptic Labs. All rights reserved.
//

import Foundation

import RxSwift

class JokeRepository {
    static var favorites = [Joke]()

    func saveFavorite(joke: Joke) -> Observable<Bool> {
        if JokeRepository.favorites.contains(where: {$0.id == joke.id}) { return Observable.just(true) }
        JokeRepository.favorites.append(joke)
        return Observable.just(true)
    }

    func readFavorites() -> Observable<[Joke]> {
        return Observable.just(JokeRepository.favorites)
    }
}

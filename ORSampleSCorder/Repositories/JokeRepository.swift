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
    func saveFavorite(joke: Joke) -> Observable<Bool> {
        print("\(joke.id) is a favorite\n\(joke.text)")
        return Observable.just(true)
    }
}

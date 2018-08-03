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
    let fileManager = FileManager.default
    let documents: URL

    init() {
        try! documents = fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }

    func saveFavorite(joke: Joke) -> Observable<Bool> {
        if jokeExists(joke: joke) { return Observable.just(true) }

        do {
            let data = try PropertyListEncoder().encode(joke)
            let jokeUrl = documents.appendingPathComponent("\(joke.id).txt")
            let success = NSKeyedArchiver.archiveRootObject(data, toFile: jokeUrl.path)

            return Observable.just(success)
        } catch {
            return Observable.just(false)
        }
    }

    func readFavorites() -> Observable<[Joke]> {
        do {
            let files = try fileManager.contentsOfDirectory(atPath: documents.path)
                .filter { $0 != "." || $0 != ".." }
                .map { documents.appendingPathComponent($0) }

            let jokes: [Joke] = files.compactMap { file in
                guard let data = NSKeyedUnarchiver.unarchiveObject(withFile: file.path) as? Data else { return nil }
                do {
                    return try PropertyListDecoder().decode(Joke.self, from: data)
                } catch {
                    return nil
                }
            }
            return Observable.just(jokes)
        } catch {
            return Observable.just([Joke]())
        }
    }

    func delete(id: Int) {
        let file = documents.appendingPathComponent("\(id).txt")
        try? fileManager.removeItem(at: file)
    }

    func jokeExists(joke: Joke) -> Bool {
        let file = documents.appendingPathComponent("\(joke.id).txt")
        return fileManager.fileExists(atPath: file.path)
    }
}

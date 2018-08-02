//
//  JokeApiClient.swift
//  ORSampleSCorder
//
//  Created by Sam Corder on 8/1/18.
//  Copyright © 2018 Synapptic Labs. All rights reserved.
//

import Foundation

import RxSwift

class JokeApiClient {

    /// Returns a random Chuck Norris joke
    ///
    /// - Parameters:
    ///   - count: Number to return, default 1
    ///   - excludeNerdy: Exclude jokes deemed to be in the nerdy category
    ///   - excludeExplicit: Exclude jokes that have explicit language
    /// - Returns: Observerable of the joke result.
    func random(count: Int = 1, excludeNerdy: Bool = false, excludeExplicit: Bool = true) -> Observable<JokeResult> {
        //http://api.icndb.com/jokes/random?exclude=[nerdy,explicit]
        let baseURL = count == 1 ? "http://api.icndb.com/jokes/random?escape=javascript" : "http://api.icndb.com/jokes/random/\(count)?escape=javascript"
        let urlStr: String
        switch (excludeNerdy, excludeExplicit) {
        case (true, true):
            urlStr = "\(baseURL)&exclude=nerdy,explicit"
        case (false, true):
            urlStr = "\(baseURL)&exclude=explicit"
        case (true, false):
            urlStr = "\(baseURL)&exclude=nerdy"
        default:
            urlStr = baseURL
        }
        guard let url = URL(string: urlStr) else {
            assertionFailure("Improper URL Format")
            return Observable.empty()
        }

        return URLSession.shared.rx.json(url: url).flatMap { (json) -> Observable<JokeResult> in
            //Need better error handling
            guard let dict = json as? [String: Any?] else { return Observable.just(JokeResult.failure) }
            guard let result = dict["type"] as? String, result == "success" else { return Observable.just(JokeResult.failure) }
            guard let value = dict["value"] as? [String: Any?] else { return Observable.just(JokeResult.failure) }
            guard let id = value["id"] as? Int else { return Observable.just(JokeResult.failure) }
            guard let joke = value["joke"] as? String else { return Observable.just(JokeResult.failure) }
            return Observable.just(JokeResult(result: "success", joke: Joke(id: id, text: joke)))
        }.observeOn(MainScheduler.asyncInstance)
    }
}

//{ "type": "success", "value": { "id": Int, "joke": String} }
struct JokeResult {
    let result: String
    let joke: Joke?
    static let failure = JokeResult(result: "failure", joke: nil)
}

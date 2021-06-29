//
//  Observable.swift
//  TravelHistory
//
//  Created by Karthikeyan on 29/06/21.
//

import Foundation

class Observable<T> {
    typealias Listener = (T) -> Void
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ value: T) {
        self.value = value
    }

    
    func bind(listener: Listener?) {
        self.listener = listener
    }
}

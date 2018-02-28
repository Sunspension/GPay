//
//  SignUpViewModel.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 22/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    
    private var _login = Observable.just(false)
    
    private var _password = Observable.just(false)
    
    var authResponse = Observable<AuthResponse>.empty()
    
    var loginAction = Observable<Void>.empty() {
        
        willSet {
            
            let loginPassword = Observable.combineLatest(login, password) { (login: $0, password: $1) }
            authResponse = newValue
                .withLatestFrom(loginPassword)
                .flatMapLatest { API.signup(login: $0.login, password: $0.password) }
        }
    }
    
    var isCanLogin: Observable<Bool> {
    
        return Observable.combineLatest(_login, _password) { !$0 && !$1 }.share(replay: 1)
    }
    
    var login = Observable.just("") {
        
        willSet {
            
            let phoneLenght = 18
            _login = newValue
                .map { $0.count != phoneLenght }
                .share(replay: 1)
        }
    }
    
    var password = Observable.just("") {
        
        willSet {
            
            let codeLenght = 4
            _password = newValue
                .map { $0.count != codeLenght }
                .share(replay: 1)
        }
    }
}

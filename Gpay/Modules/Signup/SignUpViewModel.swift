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
    
    private var bag = DisposeBag()
    
    var phoneNumber = PublishRelay<String>()
    
    var authError = PublishSubject<Swift.Error>()
    
    var loginActivity = PublishSubject<Bool>()
    
    var login = Observable.just("")
    
    var password = Observable.just("")
    
    var logedIn = PublishRelay<Void>()
    
    var isCanLogin: Observable<Bool> {
        
        let phoneLenght = 18
        let codeLenght = 4
        
        return Observable.combineLatest(login, password) { $0.count == phoneLenght && $1.count == codeLenght }
            .share(replay: 1)
    }
    
    var loginAction = Observable<Void>.empty() {
        
        willSet {
            
            let loginPassword = Observable.combineLatest(phoneNumber, password) { (login: String($0.dropFirst()), password: $1) }
            
            newValue.withLatestFrom(loginPassword)
                .map({ element -> (login: String, password: String) in
                    
                    self.loginActivity.onNext(true)
                    return element
                })
                .flatMapLatest { API.signup(login: $0.login, password: $0.password) }
                .subscribe(onNext: { auth in
                    
                    self.loginActivity.onNext(false)
                    
                    StorageManager.auth = auth
                    self.logedIn.accept(Void())
                    
                }, onError: { error in
                    
                    self.loginActivity.onNext(false)
                    self.authError.onNext(error)
                })
                .disposed(by: bag)
        }
    }
}

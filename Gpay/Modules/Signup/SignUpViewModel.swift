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
    
    private var disposeBag = DisposeBag()
    
    private var router: SingUpRoutable
    
    var phoneNumber = PublishRelay<String>()
    
    var authError = PublishSubject<Swift.Error>()
    
    var login = Observable.just("")
    
    var password = Observable.just("")
    
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
                .flatMapLatest { API.signup(login: $0.login, password: $0.password) }
                .subscribe(onNext: { result in
                    
                    result.onError { error in self.authError.onNext(error) }
                    result.onSucess { auth in
                        
                        StorageManager.auth = auth
                        self.router.openRootController()
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    init(router: SingUpRoutable) {
        
        self.router = router
    }
}

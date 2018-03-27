//
//  GpayTests.swift
//  GpayTests
//
//  Created by Vladimir Kokhanevich on 19/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa

@testable import Gpay

class GpayTests: XCTestCase {
    
    private let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSingUp() {
        
        let promise = expectation(description: "Singup")
        
        let viewModel = SignUpViewModel()
        
        viewModel.password = Observable.just("1111")
        
        viewModel.loginAction = Observable.create({ observer -> Disposable in
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                
                observer.on(.next(Void()))
            })
            
            return Disposables.create()
        })
        
        viewModel.phoneNumber.accept("71111111112")
        
        viewModel.logedIn.bind(onNext: { auth in
            
            XCTAssert(!auth.token.isEmpty)
            promise.fulfill()
            
        }).disposed(by: bag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testLoadStations() {
        
        let viewModel = MapsViewModel()
        let promise = expectation(description: "load stations")
        
        viewModel.stations
            .bind { stations in
                
                XCTAssert(stations.count > 0)
                promise.fulfill()
                
            }.disposed(by: bag)
        
        viewModel.viewDidLoad.accept(Void())
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

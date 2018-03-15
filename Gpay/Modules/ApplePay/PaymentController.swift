//
//  PaymentController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 07/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import PassKit
import RxSwift

class PaymentController: NSObject {
    
    static let supportedNetworks: [PKPaymentNetwork] = [.masterCard, .visa]
    
    private var paymentController: PKPaymentAuthorizationController?
    
    private var orderId: String?
    
    private let bag = DisposeBag()
    
    func startPayment(with order: Order, orderId: String) {
        
        self.orderId = orderId
        let request = self.makeRequest(with: order)
        paymentController = PKPaymentAuthorizationController(paymentRequest: request)
        paymentController!.delegate = self
        paymentController!.present { _ in }
    }
    
    private func makeRequest(with order: Order) -> PKPaymentRequest {
        
        let label = "Топливо: " + order.nozzle.fuel.name + "\nобъем: \(order.liters) л"
        let amount = order.liters * order.nozzle.fuel.price
        let fuel = PKPaymentSummaryItem(label: label, amount: NSDecimalNumber(value: amount), type: .final)
        let to = PKPaymentSummaryItem(label: "Газпромнефть", amount: NSDecimalNumber(value: amount), type: .final)
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = [fuel, to]
        paymentRequest.merchantIdentifier = "merchant.com.gpn.gpay"
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "RU"
        paymentRequest.currencyCode = "RUB"
        paymentRequest.supportedNetworks = PaymentController.supportedNetworks
        
        return paymentRequest
    }
}

extension PaymentController: PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment,
                                        completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        guard payment.token.paymentData.count > 0 else { return completion(.failure) }
        
        let base64 = payment.token.paymentData.base64EncodedData()
        let string = String(data: base64, encoding: .utf8)!
        
        API.makePayment(orderId: self.orderId!, paymentData: string)
            .subscribe(onSuccess: { result in
                
                result.onSucess({ _ in completion(.success) })
                result.onError({ _ in completion(.failure) })
                
            }, onError: { _ in completion(.failure) })
            .disposed(by: bag)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        
        controller.dismiss(completion: nil)
    }
}

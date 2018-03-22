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
    
    private let _bag = DisposeBag()
    
    private var orderId: String?
    
    private var order: Order?
    
    private var payment: Payment?
    
    
    func paymentController(order: Order, orderId: String) -> PKPaymentAuthorizationViewController? {
        
        let request = makePaymentRequest(with: order)
        self.orderId = orderId
        let controller = PKPaymentAuthorizationViewController(paymentRequest: request)
        controller?.delegate = self
        
        return controller
    }
    
    private func makePaymentRequest(with order: Order) -> PKPaymentRequest {
        
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
        paymentRequest.supportedNetworks = [.masterCard, .visa]
        
        return paymentRequest
    }
    
    private func paymentNotify() {
        
        let notification = Notification(name: Notification.Name(Constants.Notification.successPayment))
        NotificationCenter.default.post(notification)
    }
}

extension PaymentController: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController,
                                            didAuthorizePayment payment: PKPayment,
                                            completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        guard payment.token.paymentData.count > 0 else { return completion(.failure) }
        
        let base64 = payment.token.paymentData.base64EncodedData()
        let string = String(data: base64, encoding: .utf8)!
        
        API.makePayment(orderId: orderId!, paymentData: string)
            .subscribe(onSuccess: { [weak self] payment in
                
                guard payment.isSuccess else { return completion(.failure) }
                self?.payment = payment
                completion(.success)
                
            }, onError: { _ in completion(.failure) }).disposed(by: _bag)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        controller.dismiss(animated: true) {
            
            guard self.payment != nil else { return }
            self.paymentNotify()
        }
    }
}

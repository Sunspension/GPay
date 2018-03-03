//
//  GoogleMapsExtensions.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 03/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import GoogleMaps

public extension Reactive where Base: GMSMapView {
    
    public var animate: AnyObserver<GMSCameraUpdate> {
        
        return Binder(base) { control, update in
            
            control.animate(with: update) }.asObserver()
    }
}

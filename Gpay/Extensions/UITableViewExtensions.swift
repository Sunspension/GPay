//
//  UITableViewExtensions.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 21/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register(cellClass: AnyClass) {
        
        self.register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
    }
    
    func register(nibClass: AnyClass) {
        
        self.register(UINib(nibName: String(describing: nibClass), bundle: nil), forCellReuseIdentifier: String(describing: nibClass))
    }
    
    func register(headerFooterCellClass: AnyClass) {
        
        self.register(headerFooterCellClass, forHeaderFooterViewReuseIdentifier: String(describing: headerFooterCellClass))
    }
    
    func register(headerFooterNibClass: AnyClass) {
        
        self.register(UINib(nibName: String(describing: headerFooterNibClass), bundle: nil),
                      forHeaderFooterViewReuseIdentifier: String(describing: headerFooterNibClass))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
    
    func setHeaderBackgroundColor(_ color: UIColor) {
        
        self.setValue(color, forKey: "tableHeaderBackgroundColor")
    }
    
    func hideEmptyCells() {
        
        self.tableFooterView = UIView()
    }
    
    func showBusy() {
        
        DispatchQueue.main.async {
            
            let busy = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            busy.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
            busy.hidesWhenStopped = true
            busy.startAnimating()
            
            self.tableFooterView = busy
        }
    }
    
    func hideBusy() {
        
        DispatchQueue.main.async {
            
            self.tableFooterView = nil
        }
    }
}

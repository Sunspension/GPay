//
//  TableViewCellBase.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 19/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

class TableViewCellBase: UITableViewCell {
    
    private var separator: UIView {
        
        let view = UIView()
        view.backgroundColor = .separatorGray
        return view
    }
    
    private lazy var topSeparator: UIView = {
        
        self.separator
    }()
    
    private lazy var bottomSeparator: UIView = {
        
        self.separator
    }()
    
    var isNeedAddTopSeparator = false
    
    var isNeedAddBottomSeparator = false
    
    var topSeparatorLeftMargin: CGFloat = 0
    
    var bottomSeparatorLeftMargin: CGFloat = 0
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if isNeedAddTopSeparator {
            
            if self.topSeparator.superview == nil {
                
                self.addSubview(self.topSeparator)
            }
            
            let frame = self.bounds
            self.topSeparator.frame = CGRect(x: 0 + topSeparatorLeftMargin, y: 0, width: frame.width - topSeparatorLeftMargin, height: 0.5)
        }
        
        if isNeedAddBottomSeparator {
            
            if self.bottomSeparator.superview == nil {
                
                self.addSubview(self.bottomSeparator)
            }
            
            let frame = self.bounds
            self.bottomSeparator.frame = CGRect(x: 0 + bottomSeparatorLeftMargin, y: frame.maxY - 0.5, width: frame.width - bottomSeparatorLeftMargin, height: 0.5)
        }
    }
}


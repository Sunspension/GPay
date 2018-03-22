//
//  DispensersCell.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 19/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift

class DispensersCell: TableViewCellBase {

    private var _bag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var onDidSelectItem: ((_ path: IndexPath) -> Void)?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
        isNeedAddBottomSeparator = true
        setupCollectionView()
    }

    override func prepareForReuse() {
        
        _bag = DisposeBag()
        setupCollectionView()
    }
    
    func configure(_ selectedIndex: Int?, _ items: [(index: Int, dispenser: Dispenser?)]) {
        
        Observable.just(items).bind(to: collectionView.rx.items) { collectionView, row, item in
            
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dispenser", for: indexPath) as! DispenserCell
            
            cell.configure(item)
            return cell
            
        }.disposed(by: _bag)
        
        guard let index = selectedIndex else { return }
        
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    private func setupCollectionView() {
        
        collectionView.rx.itemSelected
            .bind(onNext: { [unowned self] indexPath in
                
                let cell = self.collectionView.cellForItem(at: indexPath)
                cell?.isSelected = true
                self.onDidSelectItem?(indexPath)
            })
            .disposed(by: _bag)
        
        collectionView.rx.itemDeselected
            .bind(onNext: { [unowned self] indexPath in
                
                let cell = self.collectionView.cellForItem(at: indexPath)
                cell?.isSelected = false
            })
            .disposed(by: _bag)
        
        collectionView.rx.willDisplayCell
            .bind(onNext: { [unowned self] info in
                
                guard let paths = self.collectionView.indexPathsForSelectedItems else { return }
                
                if paths.contains(info.at) {
                    
                    DispatchQueue.main.async {
                        
                        info.cell.isSelected = true
                    }
                }
            })
            .disposed(by: _bag)
    }
}

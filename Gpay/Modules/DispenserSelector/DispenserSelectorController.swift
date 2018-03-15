//
//  DispenserSelectorController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 06/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class DispenserSelectorController: UIViewController {
    
    private var bag = DisposeBag()
    
    private lazy var footer: UIView = {
        
        let view = UIView.loadFromNib(view: TableFooterView.self)!
        view.autoresizingMask = .flexibleWidth
        return view
    }()
    
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var action: RoundedButton!
    
    @IBOutlet weak var actionBottomSpace: NSLayoutConstraint!
    
    var viewModel: DispenserSelectorViewModel! {
        
        willSet {
            
            self.rx.viewDidLoad
                .bind(to: newValue.viewDidLoad)
                .disposed(by: bag)
        }
    }
    
    var router: DispenserSelectorRoutable!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupViewModel()
        setupView()
        setupCollectionView()
        hideAllViews()
        setupTableView()
    }
    
    @available(iOS 11.0, *)
    override func viewLayoutMarginsDidChange() {
        
        super.viewLayoutMarginsDidChange()
        
        if self.view.directionalLayoutMargins.bottom == 0 {
            
            self.actionBottomSpace.constant = 20
        }
    }
    
    private func setupView() {
        
        action.setButtonColor(.mainBlue)
        action.enableShadow(color: .mainBlue)
        
        separator.backgroundColor = .separatorGray
        
        let right = UIBarButtonItem(image: R.image.close(), style: .plain, target: self, action: #selector(onDismiss))
        self.navigationItem.rightBarButtonItem = right
    }
    
    @objc private func onDismiss() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
    }
    
    private func hideAllViews() {
        
        self.separator.isHidden = true
        self.action.isHidden = true
        self.tableView.isHidden = true
        self.mainTitle.isHidden = true
    }
    
    private func showAllViews() {
        
        self.separator.isHidden = false
        self.action.isHidden = false
        self.tableView.isHidden = false
        self.mainTitle.isHidden = false
    }
    
    private func setupViewModel() {
        
        viewModel.loadingActivity
            .subscribe(onNext: { isActive in
            
            if isActive {
                
                self.showBusy()
            }
            else {
                
                self.hideBusy()
            }
            
        }).disposed(by: bag)
        
        viewModel.dispensers
            .bind(onNext: self.onDispensers(_:))
            .disposed(by: bag)
        
        let animation = AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .top)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<FuelSection>(animationConfiguration: animation, configureCell: { (dataSource, tableView, indexPath, item) in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FuelCell", for: indexPath) as! FuelCell
            cell.configure(item)
            return cell
        })
        
        viewModel.fuelSection
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.isCanMakePayments
            .bind(to: action.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.makeOrder = action.rx.tap.asObservable()
        
        viewModel.order
            .asObservable()
            .filter({ $0 != nil })
            .subscribe(onNext: { order in
            
                let station = self.viewModel.station
                self.router.openOrderDetails(order: order!, station: station, in: self)
            
        }).disposed(by: bag)
        
        viewModel.error
            .bind(onNext: onError(_:))
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                
                self.viewModel.selectedFuelIndex.accept(indexPath.row)
                
            }).disposed(by: bag)
    }
    
    private func onError(_ error: Swift.Error) {
        
        self.showError(error: error)
    }
    
    private func onDispensers(_ dispensers: [Dispenser]) {
        
        self.showAllViews()
        createCollectionViewDataSource(dispensers)
    }
    
    private func setupCollectionView() {
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                
                let index = indexPath.row
                self.setTitle(index)
                self.viewModel.onDidSelectDispenser(index)
                
                let cell = self.collectionView.cellForItem(at: indexPath)
                cell?.isSelected = true
            })
            .disposed(by: bag)
        
        collectionView.rx.itemDeselected
            .subscribe(onNext: { [unowned self] indexPath in
                
                let cell = self.collectionView.cellForItem(at: indexPath)
                cell?.isSelected = false
            })
            .disposed(by: bag)
    }
    
    private func setTitle(_ dispenserIndex: Int) {
        
        mainTitle.text = "Колонка № \(dispenserIndex + 1)"
    }
    
    private func createCollectionViewDataSource(_ dispensers: [Dispenser]) {
        
        Observable.just([0, 1, 2, 3, 4, 5, 6, 7])
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                
                let indexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Dispenser", for: indexPath) as! DispenserCell
                cell.index.setTitle("\(row + 1)", for: .normal)
                
                guard dispensers.count > row else { return cell }
                
                cell.isActive = true
                
//                let dispenser = self.dispensers[row]
                
                return cell
                
            }.disposed(by: bag)
    }
}

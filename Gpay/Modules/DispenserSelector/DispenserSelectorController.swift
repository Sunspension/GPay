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
    
    private let bag = DisposeBag()
    
    private var selectedDispenserIndex = BehaviorRelay<Int?>(value: nil)
    
    private var showCalculator = BehaviorRelay<Bool>(value: false)
    
    private var kHeight: CGFloat?
    
    private var isCalculatorVisible = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calculatorContainer: UIView!
    
    @IBOutlet weak var calculatorBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var action: RoundedButton!
    
    @IBOutlet weak var currency: UILabel!
    
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var liters: UITextField!
    
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
        setupDataSource()
        setupView()
        hideAllViews()
        setupTableView()
        setupKeyboardNotification()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    private func setupKeyboardNotification() {
        
        self.rx.keyboardHeight
            .bind { [unowned self] height in

                if height == 0 {

                    if self.showCalculator.value && self.kHeight != nil {
                        
                        self.calculatorBottomMargin.constant += self.kHeight!
                        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
                    }
                }
                else {

                    if self.showCalculator.value {
                        
                        self.kHeight = height
                        self.calculatorBottomMargin.constant -= height
                        let bottom = height + self.calculatorContainer.bounds.height
                        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: bottom, right: 0)
                    }
                }

                if let path = self.tableView.indexPathForSelectedRow {
                    
                    self.tableView.scrollToRow(at: path, at: .middle, animated: false)
                }
                
                UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })

        }.disposed(by: bag)
    }
    
    private func setupView() {
        
        let right = UIBarButtonItem(image: R.image.close(), style: .plain, target: self, action: #selector(onDismiss))
        self.navigationItem.rightBarButtonItem = right
        
        let layer = calculatorContainer.layer
        layer.shadowOpacity = 0.05
        layer.shadowOffset = CGSize(width: 0, height: -10)
        layer.shadowRadius = 7
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        
        action.setButtonColor(.mainBlue)
        action.enableShadow(color: .mainBlue)
        
        self.showCalculator
            .bind(onNext: { [unowned self] show in
            
                if show {
                    
                    self.displayCalculator()
                }
                else {
                    
                    self.hideKeyboard()
                    self.hideCalculator()
                }
            
        }).disposed(by: bag)
        
        currency.text = "\u{20BD}"
    }
    
    private func displayCalculator() {
        
        if isCalculatorVisible {
            
            return
        }
        
        isCalculatorVisible = true
        self.calculatorBottomMargin.constant = 0
        self.liters.becomeFirstResponder()
    }
    
    private func hideCalculator() {
        
        isCalculatorVisible = false
        self.hideKeyboard()
        self.calculatorBottomMargin.constant = 220
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.view.layoutIfNeeded()
        })
        
        self.amount.text = ""
        self.liters.text = ""
        self.viewModel.resetCalculator()
    }
    
    private func hideKeyboard() {
        
        self.view.endEditing(true)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.layoutIfNeeded()
    }
    
    @objc private func onDismiss() {
        
        self.hideKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupTableView() {
        
        self.tableView.hideEmptyCells()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    private func hideAllViews() {
        
        self.tableView.isHidden = true
    }
    
    private func showAllViews() {
        
        self.tableView.isHidden = false
    }
    
    private func setupDataSource() {
        
        let animation = AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .fade, deleteAnimation: .fade)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<DispenserSelectorSection>(animationConfiguration: animation, configureCell: { [unowned self] (dataSource, tableView, indexPath, item) in
            
            switch item.type {
                
            case .title(let text):
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "Title", for: indexPath) as! TitleCell
                cell.mainTitle.text = text
                
                self.selectedDispenserIndex
                    .asObservable()
                    .filter({ $0 != nil })
                    .bind(onNext: { index in
                        
                        cell.mainTitle.text = "Колонка № \(index! + 1)"
                    })
                    .disposed(by: cell.bag)
                
                return cell
                
            case .dispensers(let items):
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "DispensersCell", for: indexPath) as! DispensersCell
                cell.configure(self.selectedDispenserIndex.value, items)
                cell.onDidSelectItem = { path in
                    
                    let index = path.row
                    self.selectedDispenserIndex.accept(index)
                    self.viewModel.onDidSelectDispenser(index)
                    self.showCalculator.accept(false)
                }
                
                return cell
                
            case .fuel(let fuel):
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "FuelCell", for: indexPath) as! FuelCell
                cell.configure(fuel)
                return cell
            }
        })
        
        viewModel.sections
            .asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
    }
    
    private func setupViewModel() {
        
        viewModel.loadingActivity
            .subscribe(onNext: { [unowned self] isActive in
            
            if isActive {
                
                self.showBusy()
            }
            else {
                
                self.hideBusy()
                self.showAllViews()
            }
            
        }).disposed(by: bag)
        
        viewModel.order
            .asObservable()
            .filter({ $0 != nil })
            .bind(onNext: { [unowned self] order in
                
                let station = self.viewModel.station
                self.router.openOrderDetails(order: order!, station: station, in: self)
            })
            .disposed(by: bag)
        
        viewModel.payment
            .asObservable()
            .filter({ $0 != nil })
            .bind(onNext: { [unowned self] pair in
                
                self.router.openPaymentController(order: pair!.order, orderId: pair!.orderId, in: self)
            })
            .disposed(by: bag)
        
        viewModel.successPayment
            .asObservable()
            .filter({ $0 != nil })
            .bind(onNext: { [unowned self] orderId in
                
                let orderNumber = self.viewModel.orderResponse!.orderNumber
                self.router.openOrderStatusController(orderId: orderId!, orderNumber: orderNumber, in: self)
                
            }).disposed(by: bag)
        
        viewModel.error
            .bind(onNext: { [unowned self] in self.onError($0) })
            .disposed(by: bag)
        
        viewModel.isCanMakePayments
            .bind(to: self.action.rx.isEnabled)
            .disposed(by: bag)
        
        viewModel.amount
            .bind(to: self.amount.rx.text)
            .disposed(by: bag)
        
        self.viewModel.makeOrder = self.action.rx.tap
            .asObservable().map({ [unowned self] in self.hideKeyboard() })
            .asObservable()
        
        self.liters.rx.text.orEmpty
            .bind(to: self.viewModel.liters)
            .disposed(by: bag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                
                if indexPath.section == 0 { return }
                self.viewModel.selectedFuelIndex.accept(indexPath.row)
                self.showCalculator.accept(true)
                
            }).disposed(by: bag)
    }
    
    private func onError(_ error: Swift.Error) {
        
        self.showError(error: error)
    }
}

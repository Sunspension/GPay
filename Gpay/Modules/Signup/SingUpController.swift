//
//  SingUpController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 21/02/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private enum Item {
    
    case logo, title, phone, code, action
}

class SingUpController: UITableViewController {

    private var disposeBag = DisposeBag()
    
    private let items: [Item] = [.logo, .title, .phone, .code, .action]
    
    var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configureDataSource()
        self.configureNotificationCenter()
        self.hideKeyboardHandler()
    }
    
    init() {
        
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    
    private func configureNotificationCenter() {
        
        NotificationCenter.default.rx
            .notification(NSNotification.Name.UIKeyboardWillShow)
            .asObservable()
            .subscribe { notification in
                
                DispatchQueue.main.async {
                    
                    let count = self.items.count
                    let indexPath = IndexPath(row: count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                
        }.disposed(by: disposeBag)
    }
    
    private func hideKeyboardHandler() {
        
        let tapBackground = UITapGestureRecognizer()
        
        tapBackground.rx
            .event
            .subscribe(onNext: { [unowned self] _ in self.view.endEditing(true) })
            .disposed(by: disposeBag)
        
        self.view.addGestureRecognizer(tapBackground)
    }
    
    private func configureDataSource() {
        
        self.tableView.dataSource = nil
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        self.tableView.separatorStyle = .none
        
        self.tableView.hideEmptyCells()
        self.tableView.register(nibClass: LabelCell.self)
        self.tableView.register(nibClass: ImageViewCell.self)
        self.tableView.register(nibClass: PhoneCell.self)
        self.tableView.register(nibClass: ButtonCell.self)
        
        self.viewModel.loginActivity
            .asObservable()
            .subscribe(onNext: { isActive in
                
                if isActive == true {
                    
                    self.tableView.showBusy()
                }
                else {
                    
                    self.tableView.hideBusy()
                }
                
            }).disposed(by: disposeBag)
                
        Observable.just(items)
            .bind(to: tableView.rx.items) { table, row, item in
            
            let indexPath = IndexPath(row: row, section: 0)
            
            switch item {
                
            case .logo:
                
                let cell: ImageViewCell = table.dequeueReusableCell(for: indexPath)
                cell.selectionStyle = .none
                return cell
                
            case .title:
                
                let cell: LabelCell = table.dequeueReusableCell(for: indexPath)
                cell.selectionStyle = .none
                return cell
                
            case .phone:
                
                let cell: PhoneCell = table.dequeueReusableCell(for: indexPath)
                cell.selectionStyle = .none
                cell.phoneField.placeholder = "Телефон"
                cell.phoneField.formatter.setDefaultOutputPattern(" (###) ### ## ##")
                cell.enablePrefix()
                
                cell.phoneField.rx.phoneNumber.orEmpty.bind(to: self.viewModel.phoneNumber)
                    .disposed(by: cell.disposeBag)

                self.viewModel.login = cell.phoneField.rx.text.orEmpty.asObservable()
                
                return cell
                
            case .code:
                
                let cell: PhoneCell = table.dequeueReusableCell(for: indexPath)
                cell.selectionStyle = .none
                cell.phoneField.placeholder = "Код"
                cell.phoneField.formatter.setDefaultOutputPattern("####")
                
                self.viewModel.password = cell.phoneField.rx.text.orEmpty.asObservable()
                
                return cell
                
            case .action:
                
                let cell: ButtonCell = table.dequeueReusableCell(for: indexPath)
                cell.selectionStyle = .none
                
                self.viewModel.loginAction = cell.button.rx.tap.asObservable()
                    .map { self.view.endEditing(true) }.asObservable()
                
                self.viewModel.authError.subscribe(onNext: { error in

                    self.showOkAlert(title: "Ошибка", message: error.localizedDescription)

                }).disposed(by: cell.disposeBag)
                
                self.viewModel.isCanLogin.bind(to: cell.button.rx.isEnabled)
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            
        }.disposed(by: disposeBag)
    }
}

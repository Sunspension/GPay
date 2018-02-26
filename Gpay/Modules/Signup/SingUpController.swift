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
    
    private var login = Observable<Bool>.just(false)
    
    private var password = Observable<Bool>.just(false)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.configureDataSource()
        self.configureNotificationCenter()
        self.hideKeyboardHandler()
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
        
        self.tableView.hideEmptyCells()
        self.tableView.register(nibClass: LabelCell.self)
        self.tableView.register(nibClass: ImageViewCell.self)
        self.tableView.register(nibClass: PhoneCell.self)
        self.tableView.register(nibClass: ButtonCell.self)
        
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
                
                let phoneLenght = 18
                
                self.login = cell.phoneField.rx
                    .text
                    .orEmpty
                    .map { $0.count != phoneLenght }
                    .share(replay: 1)
                
                return cell
                
            case .code:
                
                let cell: PhoneCell = table.dequeueReusableCell(for: indexPath)
                cell.selectionStyle = .none
                cell.phoneField.placeholder = "Код"
                cell.phoneField.formatter.setDefaultOutputPattern("####")
                
                let codeLenght = 4
                
                self.password = cell.phoneField.rx
                    .text
                    .orEmpty
                    .map { $0.count != codeLenght }
                    .share(replay: 1)
                
                return cell
                
            case .action:
                
                let cell: ButtonCell = table.dequeueReusableCell(for: indexPath)
                cell.selectionStyle = .none
                cell.button.rx
                    .tap
                    .subscribe(onNext: { [weak self] _ in self?.signup() })
                    .disposed(by: cell.disposeBag)
                
                let isCanLogin = Observable.combineLatest(self.login, self.password) { !$0 && !$1 }
                    .share(replay: 1)
                
                isCanLogin
                    .bind(to: cell.button.rx.isEnabled)
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func signup() {
        
        API.signup(login: "", password: "jjjj")
            .subscribe { response in
            
            switch response {
                
            case .success(let object):
                
                print(object)
                break
                
            case .error(let error):
                
                self.showOkAlert(title: "Ошибка", message: error.localizedDescription)
                break
            }
            
        }.disposed(by: disposeBag)
        
        view.endEditing(true)
    }
}

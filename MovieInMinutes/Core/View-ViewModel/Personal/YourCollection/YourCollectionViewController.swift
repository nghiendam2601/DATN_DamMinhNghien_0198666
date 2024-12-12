//
//  YourCollectionViewController.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 25/11/24.
//

import UIKit
import SwipeCellKit

class YourCollectionViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var yourCollectionViewModel = YourCollectionViewModel()
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Methods
    func setupFirstLoad() {
        title = LanguageDictionary.myCollection.dictionary
        navigationController?.navigationBar.tintColor = .red
        
        navigationController?.isNavigationBarHidden = false
        setupViewModel()
        registerTableView(tableView, identifier: "YourCollectionTableViewCell")
        let customHeader = CustomRefreshHeader()
        self.tableView.configRefreshHeader(with: customHeader, container: self) { [weak self] in
            AppConstant.isLoading = true
            self?.yourCollectionViewModel.fetchMyCollection()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleFetchMyCollection), name: .fetchMyCollection, object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(showCreateList))
    }
    
    func setupViewModel() {
        yourCollectionViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        
        yourCollectionViewModel.onFetchCollectionSuccess = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        yourCollectionViewModel.fetchMyCollection()
    }
    
    //MARK: - Actions
    @objc func handleFetchMyCollection() {
        yourCollectionViewModel.fetchMyCollection()
        title = LanguageDictionary.myCollection.dictionary
    }
    
    @objc func showCreateList() {
        let popoverSize = CGSize(width: view.bounds.width - 40, height: 190)
        let startPoint = CGPoint(x: view.bounds.midX, y: 300)
        let createList = CreateList(frame: CGRect(origin: .zero, size: popoverSize))
        let options: [PopoverOption] = [
            .cornerRadius(popoverSize.height / 7),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.black.withAlphaComponent(0.3))
        ]
        let popover = Popover(options: options)
        createList.onCreate = { [weak self] name,des in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                if name.isEmpty {
                    weakSelf.showAlert(title: LanguageDictionary.nameRequired.dictionary, message: "")
                    popover.dismiss()
                } else {
                    weakSelf.yourCollectionViewModel.onCreateSuccess = {
                        weakSelf.yourCollectionViewModel.fetchMyCollection()
                        popover.dismiss()
                    }
                    weakSelf.yourCollectionViewModel.createList(name: name, des: des)
                }
            }
            
        }
        popover.show(createList, point: startPoint)
    }
    
}

extension YourCollectionViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yourCollectionViewModel.collection?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourCollectionTableViewCell") as? YourCollectionTableViewCell else { return UITableViewCell() }
        
        cell.label.text = yourCollectionViewModel.collection?.results[indexPath.row].name
        cell.labelQuantity.text = "\(yourCollectionViewModel.collection?.results[indexPath.row].itemCount ?? 0) \(LanguageDictionary.itemMovie.dictionary)"
        cell.lblDes.text = yourCollectionViewModel.collection?.results[indexPath.row].description
        cell.delegate = self
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "DetailListViewController", bundle: nil).instantiateViewController(identifier: "DetailListViewController") as? DetailListViewController,
              let list = yourCollectionViewModel.collection?.results[indexPath.row] else { return }
        vc.list = list
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension YourCollectionViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: LanguageDictionary.delete.dictionary) { [weak self] action, indexPath in
            guard let weakSelf = self,
                  let list = weakSelf.yourCollectionViewModel.collection?.results[indexPath.row] else { return }
            
            weakSelf.yourCollectionViewModel.deleteList(listID: list.id)
            weakSelf.yourCollectionViewModel.onDeleteListSuccess = {
                DispatchQueue.main.async {
                    weakSelf.yourCollectionViewModel.collection?.results.remove(at: indexPath.row)
                    weakSelf.tableView.reloadData()
                }
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
}

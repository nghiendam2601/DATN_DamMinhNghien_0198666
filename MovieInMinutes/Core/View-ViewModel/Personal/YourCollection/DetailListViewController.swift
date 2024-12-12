//
//  DetailListViewController.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 25/11/24.
//

import UIKit
import SwipeCellKit

class DetailListViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var detailListViewModel = DetailListViewModel()
    var list: MyListModel?
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Actions
    @objc func handleReloadTableView() {
        navigationController?.popViewController(animated: true)
    }
    @objc func handleDeleteList() {
        showAlertWithTwoOptions(title: LanguageDictionary.clearListConfirmation.dictionary, message: "") { [weak self] in
            guard let weakSelf = self,
                  let list = weakSelf.list else { return }
            weakSelf.detailListViewModel.clearList(listID: list.id)
        }
    }
    
}

//MARK: - Setup methods
extension DetailListViewController {
    
    func setupFirstLoad() {
        guard let list = list else { return }
        title = "\(list.name)"
        navigationController?.navigationBar.tintColor = .red
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "clear"),
            style: .plain,
            target: self,
            action: #selector(handleDeleteList))
        tableView.register(UINib(nibName: "YourItemTableViewCell", bundle: nil), forCellReuseIdentifier: "YourItemTableViewCell")
        setupViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(handleReloadTableView), name: .popWhenAddSuccess, object: nil)
    }
    
    func setupViewModel() {
        guard let list = list else { return }
        detailListViewModel.fetchDetaiList(listID: list.id)
        detailListViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
            }
        }
        
        detailListViewModel.onFetchDetailListSuccess = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
            }
        }
        
        detailListViewModel.onClearSuccess = { [weak self] in
            guard let weakSelf = self,
                  let list = weakSelf.list else { return }
            DispatchQueue.main.async {
                weakSelf.detailListViewModel.fetchDetaiList(listID: list.id)
                NotificationCenter.default.post(name: .fetchMyCollection, object: nil)
            }
        }
    }
    
}

extension DetailListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailListViewModel.movies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourItemTableViewCell", for: indexPath) as? YourItemTableViewCell,
              let movie = detailListViewModel.movies?[indexPath.row] else { return UITableViewCell() }
        cell.delegate = self
        cell.configureCell(movie: movie)
        cell.yourRatingStack.isHidden = true
        return cell
    }
    
}

extension DetailListViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: LanguageDictionary.delete.dictionary) { [weak self] action, indexPath in
            guard let weakSelf = self,
                  let list = weakSelf.list,
                  let movie = weakSelf.detailListViewModel.movies?[indexPath.row] else { return }
            
            weakSelf.detailListViewModel.removeMovieFromList(listID: list.id, movieID: movie.id)
            weakSelf.detailListViewModel.onRemoveMovieSuccess = {
                DispatchQueue.main.async {
                    weakSelf.detailListViewModel.movies?.remove(at: indexPath.row)
                    weakSelf.tableView.deleteRows(at: [indexPath], with: .fade)
                    NotificationCenter.default.post(name: .fetchMyCollection, object: nil)
                }
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
}

//
//  ActorDetailViewController.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 27/11/24.
//

import UIKit

class ActorDetailViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var detailViewModel = ActorDetailViewModel()
    var id: Int?
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func languageDidChange(){
        guard let id = id else { return }
        detailViewModel.fetchMovieList(id: id)    }
    
    func setup() {
        registerTableView(tableView, identifier: "ActorDetailTableViewCell")
        registerTableView(tableView, identifier: "SecondActorTableViewCell")
        let customHeader = CustomRefreshHeader()
        self.tableView.configRefreshHeader(with: customHeader, container: self) { [weak self] in
            guard let id = self?.id else { return }
            AppConstant.isLoading = true
            self?.detailViewModel.fetchMovieList(id: id)
        }
        detailViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
            weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
        }
        detailViewModel.onFetchSucceed = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
            weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
        }
        guard let id = id else { return }
        detailViewModel.fetchMovieList(id: id)
    }
    
}

//MARK: - TableView
extension ActorDetailViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActorDetailTableViewCell", for: indexPath) as? ActorDetailTableViewCell else { return UITableViewCell() }
            cell.setupData(actor: detailViewModel.actor)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondActorTableViewCell", for: indexPath) as? SecondActorTableViewCell else { return UITableViewCell() }
            cell.setupData(actor: detailViewModel.actor)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

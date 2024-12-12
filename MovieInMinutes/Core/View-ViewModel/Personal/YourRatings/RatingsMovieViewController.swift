//
//  RatingsMovieViewController.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 24/11/24.
//

import UIKit

class RatingsMovieViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var ratingsMovieViewModel = RatingsMovieViewModel()
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func languageDidChange() {
        ratingsMovieViewModel.fetchRatedMovies()
    }
    
    func setupFirstLoad() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        let customHeader = CustomRefreshHeader()
        self.tableView.configRefreshHeader(with: customHeader, container: self) { [weak self] in
            AppConstant.isLoading = true
            self?.ratingsMovieViewModel.fetchRatedMovies()
        }
        tableView.register(UINib(nibName: "YourItemTableViewCell", bundle: nil), forCellReuseIdentifier: "YourItemTableViewCell")
        ratingsMovieViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        ratingsMovieViewModel.onFetchRatedMovies = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        ratingsMovieViewModel.fetchRatedMovies()
    }
    
}

//MARK: - TableView
extension RatingsMovieViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ratingsMovieViewModel.movies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "YourItemTableViewCell", for: indexPath) as? YourItemTableViewCell,
              let movie = ratingsMovieViewModel.movies?[indexPath.row] else { return UITableViewCell() }
        cell.configureCell(movie: movie)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let movie = ratingsMovieViewModel.movies?[indexPath.row] {
            guard let vc = UIStoryboard(name: Identifier.detailMovieViewController, bundle: nil).instantiateViewController(withIdentifier: Identifier.detailMovieViewController) as? DetailMovieViewController else { return }
            vc.movieID = movie.id
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

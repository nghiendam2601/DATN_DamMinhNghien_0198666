import UIKit

class MovieViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    var movieViewModel = MovieViewModel()
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoad()
        
        let customHeader = CustomRefreshHeader()
        self.tableView.configRefreshHeader(with: customHeader, container: self) { [weak self] in
            AppConstant.isLoading = true
            self?.fetchMovieViewModel()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Actions
    @objc func languageDidChange() {
        title = LanguageDictionary.movies.dictionary
        fetchMovieViewModel()
    }
    
}

//MARK: - Setup Methods
extension MovieViewController {
    
    func setupFirstLoad() {
        self.tabBarItem.image = UIImage(named: "movieclapper.fill")
        title = LanguageDictionary.movies.dictionary
        registerTableView(tableView, identifier: "ListTopicTableViewCell")
        registerTableView(tableView, identifier: "FirstTableViewCell")
        setupMovieViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
    
    func setupMovieViewModel() {
        movieViewModel.onLoadMovieLists = { [weak self] (nowPlaying, popular, topRated, upcoming, trending) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        movieViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        fetchMovieViewModel()
    }
    
    
    func fetchMovieViewModel() {
        guard let user = RealmManager.shared.currentUser else { return }
        movieViewModel.fetchMovieList(accountID: user.id, sessionID: user.sessionID)
    }
    
}

//MARK: - TableView
extension MovieViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listTopicCell = tableView.dequeueReusableCell(withIdentifier: "ListTopicTableViewCell", for: indexPath) as? ListTopicTableViewCell else {
            return UITableViewCell()
        }
        print(indexPath.row)
        switch indexPath.row {
        case 0:
            guard let trendingCell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell") as? FirstTableViewCell else {
                return UITableViewCell()
            }
            trendingCell.movieList = movieViewModel.trending
            trendingCell.onSelectDetail = { [weak self] movie in
                guard let weakSelf = self else { return }
                guard let vc = UIStoryboard(name: Identifier.detailMovieViewController, bundle: nil).instantiateViewController(withIdentifier: Identifier.detailMovieViewController) as? DetailMovieViewController else {
                    return
                }
                vc.movieID = movie.id
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }
            return trendingCell
        case 1:
            listTopicCell.movieList = movieViewModel.nowPlaying
            listTopicCell.movieListType = .NowPlaying
        case 2:
            listTopicCell.movieList = movieViewModel.popular
            listTopicCell.movieListType = .Popular
        case 3:
            listTopicCell.movieList = movieViewModel.topRated
            listTopicCell.movieListType = .TopRated
        case 4:
            listTopicCell.movieList = movieViewModel.upcoming
            listTopicCell.movieListType = .Upcoming
        default:
            return UITableViewCell()
        }
        
        listTopicCell.onTapSeeAll = { [weak self] movieList in
            guard let weakSelf = self,
                  let movieListCurrent = movieList as? [MovieModel] else { return }
            let vc = setupSeeAllViewController(listType: .Movie, movieList: movieListCurrent, tvSeriesList: nil, movieListType: listTopicCell.movieListType, tvSeriesListType: nil, seasonList: nil)
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
        listTopicCell.onTapDetail = { [weak self] movie in
            guard let weakSelf = self,
                  let movieCurrent = movie as? MovieModel else { return }
            guard let vc = UIStoryboard(name: Identifier.detailMovieViewController, bundle: nil).instantiateViewController(withIdentifier: Identifier.detailMovieViewController) as? DetailMovieViewController else {
                return
            }
            vc.movieID = movieCurrent.id
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
        return listTopicCell
    }
    
}

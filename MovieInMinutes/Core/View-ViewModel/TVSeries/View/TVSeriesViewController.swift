import UIKit

class TVSeriesViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    var tvSeriesViewModel = TVSeriesViewModel()
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirstLoad()
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
        title = LanguageDictionary.tvSeries.dictionary
        fetchTVSeriesList()
    }
    
}
//MARK: - Setup Methods
extension TVSeriesViewController {
    
    func setupFirstLoad() {
        self.tabBarItem.image = UIImage(named: "tv.fill")
        title = LanguageDictionary.tvSeries.dictionary
        registerTableView(tableView, identifier: "ListTopicTableViewCell")
        registerTableView(tableView, identifier: "FirstTableViewCell")
        setupTVSeriesViewModel()
        let customHeader = CustomRefreshHeader()
        self.tableView.configRefreshHeader(with: customHeader, container: self) { [weak self] in
            AppConstant.isLoading = true
            self?.fetchTVSeriesList()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
    
    func setupTVSeriesViewModel() {
        fetchTVSeriesList()
        tvSeriesViewModel.onLoadTVSeriesLists = { [weak self] (airingToday, popular, topRated, onTheAir) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        tvSeriesViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
    }
    
    func fetchTVSeriesList() {
        guard let user = RealmManager.shared.currentUser else { return }
        tvSeriesViewModel.fetchTVSeriesList(accountID: user.id, sessionID: user.sessionID)
    }
    
}

//MARK: - TableView
extension TVSeriesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let listTopicCell = tableView.dequeueReusableCell(withIdentifier: "ListTopicTableViewCell", for: indexPath) as? ListTopicTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            guard let trendingCell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell") as? FirstTableViewCell else {
                return UITableViewCell()
            }
            trendingCell.tvSeriesList = tvSeriesViewModel.trending
            trendingCell.onSelectDetailTV = { [weak self] TV in
                guard let weakSelf = self else { return }
                guard let vc = UIStoryboard(name: Identifier.detailTVSeriesViewController, bundle: nil).instantiateViewController(withIdentifier: Identifier.detailTVSeriesViewController) as? DetailTVSeriesViewController else {
                    return
                }
                vc.tvSeriesID = TV.id
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }
            return trendingCell
        case 1:
            listTopicCell.tvSeriesList = tvSeriesViewModel.airingToday
            listTopicCell.tvSeriesListType = .AiringToday
        case 2:
            listTopicCell.tvSeriesList = tvSeriesViewModel.popular
            listTopicCell.tvSeriesListType = .Popular
        case 3:
            listTopicCell.tvSeriesList = tvSeriesViewModel.topRated
            listTopicCell.tvSeriesListType = .TopRated
        case 4:
            listTopicCell.tvSeriesList = tvSeriesViewModel.onTheAir
            listTopicCell.tvSeriesListType = .OnTheAir
        default:
            return UITableViewCell()
        }
        
        listTopicCell.onTapSeeAll = { [weak self] tvSeriesList in
            guard let weakSelf = self,
                  let tvSeriesListCurrent = tvSeriesList as? [TVSeriesModel] else { return }
            let vc = setupSeeAllViewController(listType: .TVSeries, movieList: nil, tvSeriesList: tvSeriesListCurrent, movieListType: nil, tvSeriesListType: listTopicCell.tvSeriesListType, seasonList: nil)
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
        listTopicCell.onTapDetail = { [weak self] tvSeries in
            guard let weakSelf = self,
                  let tvSeriesCurrent = tvSeries as? TVSeriesModel else { return }
            guard let vc = UIStoryboard(name: Identifier.detailTVSeriesViewController, bundle: nil).instantiateViewController(withIdentifier: Identifier.detailTVSeriesViewController) as? DetailTVSeriesViewController else {
                return
            }
            vc.tvSeriesID = tvSeriesCurrent.id
            weakSelf.navigationController?.pushViewController(vc, animated: true)
        }
        
        return listTopicCell
    }
    
}

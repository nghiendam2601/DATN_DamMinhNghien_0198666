import UIKit
import PullToRefreshKit

class DetailMovieViewController: BaseViewController {
    
    //MARK: - Outlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    var detailMovieViewModel = DetailMovieViewModel()
    var yourCollectionViewModel = YourCollectionViewModel()
    var movieID: Int?
    var addPopover: Popover?
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDetailMovieViewModel()
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
        let customHeader = CustomRefreshHeader()
        self.tableView.configRefreshHeader(with: customHeader, container: self) { [weak self] in
            AppConstant.isLoading = true
            self?.fetchDetail()
        }
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Actions
    @objc func languageDidChange() {
        fetchDetail()
    }
    
}

//MARK: - Setup Methods
extension DetailMovieViewController {
    
    private func setupTableView() {
        [Identifier.firstDetailTableViewCell, Identifier.secondDetailTableViewCell, Identifier.thirdDetailTableViewCell, Identifier.fourthDetailTableViewCell, Identifier.fifthDetailTableViewCell, Identifier.informationDetailTableViewCell].forEach {
            registerTableView(tableView, identifier: $0)
        }
    }
    
    private func setupDetailMovieViewModel() {
        
        detailMovieViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        
        detailMovieViewModel.onfetchSucceed = { [weak self] in
            DispatchQueue.main.async {
                guard let weakSelf = self,
                      let movie = weakSelf.detailMovieViewModel.movie else { return }
                DispatchQueue.main.async {
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .automatic)
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
                    weakSelf.tableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
                    weakSelf.title = movie.title
                    weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
                }
            }
        }
        detailMovieViewModel.onRatingSuccess = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        
        detailMovieViewModel.onDeleteRatingSuccess = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                guard let cell = weakSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FirstDetailTableViewCell else {
                    print("Cell không tồn tại")
                    return
                }
                cell.isRated = true
            }
        }
        detailMovieViewModel.onAdd = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: message, message: "")
                weakSelf.addPopover?.dismiss()
                NotificationCenter.default.post(name: .fetchMyCollection, object: nil)
                NotificationCenter.default.post(name: .popWhenAddSuccess, object: nil)
            }
        }
        fetchDetail()
    }
    
    func setupYourCollectionViewModel() {
        yourCollectionViewModel.fetchMyCollection()
        yourCollectionViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
            }
        }
        
        yourCollectionViewModel.onFetchCollectionSuccess = { [weak self] in
            guard let weakSelf = self,
                  let collection = weakSelf.yourCollectionViewModel.collection else { return }
            DispatchQueue.main.async {
                weakSelf.showAddListPopover(collection: collection)
            }
        }
    }
    
    func fetchDetail() {
        guard let movieID = movieID else { return }
        detailMovieViewModel.fetchMovieData(id: movieID)
    }
    
    func showRatingPopover(isRated: Bool) {
        let popoverSize = CGSize(width: 250, height: 250)
        let startPoint = CGPoint(x: view.bounds.midX, y: 300)
        let ratingView = RatingView(frame: CGRect(origin: .zero, size: popoverSize))
        guard let movieID = movieID else { return }
        guard let ratingStar = ratingView.ratingStar else { return }
        if let rate = AppConstant.moviesRated[movieID],
           movieID != 0 {
            ratingStar.value = Int(rate / 2)
        } else {
            ratingStar.value = 0
        }
        ratingView.configure(with: movieID)
        let options: [PopoverOption] = [
            .cornerRadius(popoverSize.height / 7),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.black.withAlphaComponent(0.3))
        ]
        let popover = Popover(options: options)
        popover.didDismissHandler = { [weak self] in
            guard let self = self, let movieID = self.movieID else { return }
            let rated = Int((AppConstant.moviesRated[movieID] ?? 0) / 2 )
            let selectedRating = ratingStar.value
            DispatchQueue.main.async {
                if selectedRating == rated {
                    popover.dismiss()
                } else if selectedRating != 0 {
                    self.showAlertWithTwoOptions(title: LanguageDictionary.askRated.dictionary, message: "") {
                        self.detailMovieViewModel.ratingMovie(movieID: movieID, score: selectedRating)
                    }
                } else {
                    if isRated {
                        self.showAlertWithTwoOptions(title: LanguageDictionary.askDeleteRated.dictionary, message: "") {
                            self.detailMovieViewModel.deleteRatingMovie(id: movieID)
                        }
                    }
                }
            }
        }
        popover.show(ratingView, point: startPoint)
    }
    
    func showAddListPopover(collection: MyCollectionModel) {
        let popoverSize = CGSize(width: 300, height: 300)
        let startPoint = CGPoint(x: view.bounds.midX, y: 300)
        let addList = AddList(frame: CGRect(origin: .zero, size: popoverSize))
        guard let movieID = movieID else { return }
        addList.collection = collection
        addList.onSelectAdd = { [weak self] indexPathRow in
            guard let weakSelf = self else { return }
            weakSelf.detailMovieViewModel.addList(listID: collection.results[indexPathRow].id, movieID: movieID)
        }
        let options: [PopoverOption] = [
            .cornerRadius(popoverSize.height / 7),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.black.withAlphaComponent(0.3))
        ]
        addPopover = Popover(options: options)
        addPopover?.show(addList, point: startPoint)
    }
    
}

// MARK: - TableView DataSource
extension DetailMovieViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.firstDetailTableViewCell) as? FirstDetailTableViewCell,
                  let movie = detailMovieViewModel.movie else {
                return UITableViewCell()
            }
            cell.setupCell(movie: movie)
            cell.onRatingSelected = { [weak self] isRated in
                self?.showRatingPopover(isRated: isRated)
            }
            cell.onAddListSelected = { [weak self] in
                self?.setupYourCollectionViewModel()
            }
            cell.configureCell()
            cell.addListStack.isHidden = false
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.secondDetailTableViewCell) as? SecondDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.overViewLabel.text = detailMovieViewModel.movie?.overview
            cell.overViewTitle.text = LanguageDictionary.overview.dictionary
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.thirdDetailTableViewCell) as? ThirdDetailTableViewCell else {
                return UITableViewCell()
            }
            if let cast = detailMovieViewModel.cast,
               !cast.isEmpty {
                cell.cast = cast
                cell.onSelectActor = { [weak self] id in
                    guard let weakSelf = self else { return }
                    let vc = UIStoryboard(name: "ActorDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "ActorDetailViewController") as! ActorDetailViewController
                    vc.id = id
                    weakSelf.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                return UITableViewCell()
            }
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.fourthDetailTableViewCell) as? FourthDetailTableViewCell else {
                return UITableViewCell()
            }
            cell.lblTrailer.text = LanguageDictionary.officialTrailer.dictionary
            if let key = detailMovieViewModel.key,
               !key.isEmpty {
                cell.key = key
            } else {
                return UITableViewCell()
            }
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.informationDetailTableViewCell) as? InformationDetailTableViewCell else {
                return UITableViewCell()
            }
            if let movie = detailMovieViewModel.movie {
                cell.setupData(movie: movie)
            }
            return cell
        case 5:
            guard let sessionID = RealmManager.shared.currentUser?.sessionID,
                  !sessionID.isEmpty else { let cell = UITableViewCell()
                cell.textLabel?.text = LanguageDictionary.suggestWatchReview.dictionary
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = .gray
                return cell }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.fifthDetailTableViewCell) as? FifthDetailTableViewCell else { return UITableViewCell() }
            cell.configureCell()
            cell.onSelectWatchNow = { [weak self] in
                guard let weakSelf = self,
                      let movie = weakSelf.detailMovieViewModel.movie else { return }
                guard let vc = UIStoryboard(name: "ReviewViewController", bundle: nil).instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController else {
                    return
                }
                vc.movie = movie
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 && detailMovieViewModel.cast?.isEmpty == true {
            return 0 // Ẩn hàng
        } else if indexPath.row == 3 && detailMovieViewModel.key?.isEmpty == true {
            return 0 // Ẩn hàng
        } else if indexPath.row == 4 {
            return 265
        } else if indexPath.row == 5 {
            if let sessionID = RealmManager.shared.currentUser?.sessionID,
               sessionID.isEmpty {
                return 35
            }
        }
        return UITableView.automaticDimension
    }
    
}

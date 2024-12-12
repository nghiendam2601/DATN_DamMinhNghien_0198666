//
//  DetailTVSeriesViewController.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 27/10/24.
//

import UIKit

class DetailTVSeriesViewController: BaseViewController {
    
    //MARK: - Outlét
    @IBOutlet var tableView: UITableView!
    
    //MARK: - Properties
    var detailTVSeriesViewModel = DetailTVSeriesViewModel()
    var tvSeriesID: Int?
    
    //MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupDetailTVSeriesViewModel()
        let customHeader = CustomRefreshHeader()
        self.tableView.configRefreshHeader(with: customHeader, container: self) { [weak self] in
            AppConstant.isLoading = true
            self?.fetchDetail()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Actions
    @objc func languageDidChange() {
        fetchDetail()
    }
    
}

//MARK: - Setup methods
extension DetailTVSeriesViewController {
    
    func fetchDetail() {
        guard let tvSeriesID = tvSeriesID else { return }
        detailTVSeriesViewModel.fetchTVSeriesData(id: tvSeriesID)
    }
    
    func setupTableView() {
        [Identifier.firstDetailTableViewCell, Identifier.secondDetailTableViewCell, Identifier.thirdDetailTableViewCell, Identifier.fourthDetailTableViewCell, Identifier.fifthDetailTableViewCell, Identifier.informationDetailTableViewCell,Identifier.listTopicTableViewCell].forEach {
            registerTableView(tableView, identifier: $0)
        }
    }
    
    func setupDetailTVSeriesViewModel() {
        
        detailTVSeriesViewModel.onShowAlert = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        
        detailTVSeriesViewModel.onfetchSucceed = { [weak self] in
            DispatchQueue.main.async {
                guard let weakSelf = self,
                      let tvSeries = weakSelf.detailTVSeriesViewModel.tvSeries else { return }
                DispatchQueue.main.async {
                    weakSelf.tableView.reloadData()
                    weakSelf.title = tvSeries.name
                    weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
                }
            }
        }
        detailTVSeriesViewModel.onRatingSuccess = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        
        detailTVSeriesViewModel.onDeleteRatingSuccess = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                guard let cell = weakSelf.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FirstDetailTableViewCell else {
                    print("Cell không tồn tại")
                    return
                }
                cell.isRated = true
            }
        }
        fetchDetail()
    }
    
    func showRatingPopover(isRated: Bool) {
        let popoverSize = CGSize(width: 250, height: 250)
        let startPoint = CGPoint(x: view.bounds.midX, y: 300)
        let ratingView = RatingView(frame: CGRect(origin: .zero, size: popoverSize))
        guard let tvSeriesID = tvSeriesID else { return }
        guard let ratingStar = ratingView.ratingStar else { return }
        if let rate = AppConstant.tvRated[tvSeriesID],
           tvSeriesID != 0 {
            ratingStar.value = Int(rate / 2)
        } else {
            ratingStar.value = 0
        }
        ratingView.configureTV(with: tvSeriesID)
        let options: [PopoverOption] = [
            .cornerRadius(popoverSize.height / 7),
            .animationIn(0.3),
            .blackOverlayColor(UIColor.black.withAlphaComponent(0.3))
        ]
        let popover = Popover(options: options)
        popover.didDismissHandler = { [weak self] in
            guard let self = self, let tvSeriesID = self.tvSeriesID else { return }
            let rated = Int((AppConstant.tvRated[tvSeriesID] ?? 0) / 2 )
            let selectedRating = ratingStar.value
            DispatchQueue.main.async {
                if selectedRating == rated {
                    popover.dismiss()
                } else if selectedRating != 0 {
                    self.showAlertWithTwoOptions(title: LanguageDictionary.askRated.dictionary, message: "") {
                        self.detailTVSeriesViewModel.ratingTVSeries(tvSeriesID: tvSeriesID, score: selectedRating)
                    }
                } else {
                    if isRated {
                        self.showAlertWithTwoOptions(title: LanguageDictionary.askDeleteRated.dictionary, message: "") {
                            self.detailTVSeriesViewModel.deleteRatingTVSeries(id: tvSeriesID)
                        }
                    }
                }
            }
        }
        popover.show(ratingView, point: startPoint)
    }
    
}

//MARK: - TableView
extension DetailTVSeriesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.firstDetailTableViewCell) as? FirstDetailTableViewCell,
                  let tvSeries = detailTVSeriesViewModel.tvSeries else {
                return UITableViewCell()
            }
            cell.setupCellTVSeries(tvSeries: tvSeries)
            cell.onRatingSelected = { [weak self] isRated in
                self?.showRatingPopover(isRated: isRated)
            }
            cell.configureCell()
            cell.addListStack.isHidden = true
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.secondDetailTableViewCell) as? SecondDetailTableViewCell else {
                return UITableViewCell()
            }
            if let overview = detailTVSeriesViewModel.tvSeries?.overview, !overview.isEmpty {
                cell.overViewLabel.text = overview
                cell.overViewLabel.textAlignment = .left
            } else {
                cell.overViewLabel.text = LanguageDictionary.noData.dictionary
                cell.overViewLabel.textAlignment = .center
            }
            cell.overViewTitle.text = LanguageDictionary.overview.dictionary
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.thirdDetailTableViewCell) as? ThirdDetailTableViewCell else {
                return UITableViewCell()
            }
            if let existingLabel = cell.contentView.subviews.first(where: { $0 is UILabel }) {
                existingLabel.removeFromSuperview()
            }
            if let cast = detailTVSeriesViewModel.cast, !cast.isEmpty {
                cell.cast = cast
                cell.onSelectActor = { [weak self] id in
                    guard let weakSelf = self else { return }
                    let vc = UIStoryboard(name: "ActorDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "ActorDetailViewController") as! ActorDetailViewController
                    vc.id = id
                    weakSelf.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                let lblNoData = UILabel()
                lblNoData.translatesAutoresizingMaskIntoConstraints = false
                lblNoData.text = LanguageDictionary.noData.dictionary
                lblNoData.textAlignment = .center
                lblNoData.textColor = .labelApp
                cell.contentView.addSubview(lblNoData)
                NSLayoutConstraint.activate([
                    lblNoData.topAnchor.constraint(equalTo: cell.lblCast.bottomAnchor, constant: 8),
                    lblNoData.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor)
                ])
            }
            return cell
        case 3:
            guard let listTopicCell = tableView.dequeueReusableCell(withIdentifier: "ListTopicTableViewCell", for: indexPath) as? ListTopicTableViewCell else {
                return UITableViewCell()
            }
            listTopicCell.seasonList = detailTVSeriesViewModel.tvSeries?.seasons
            listTopicCell.seeAll.isHidden = true
            listTopicCell.onTapDetail = { [weak self] season in
                guard let weakSelf = self,
                      let season = season as? DetailSeasonModel else { return }
                guard let vc = UIStoryboard(name: "DetailSeasonViewController", bundle: nil).instantiateViewController(identifier: "DetailSeasonViewController") as? DetailSeasonViewController else { return }
                guard let tvSeriesID = weakSelf.tvSeriesID else { return }
                vc.tvSeriesID = tvSeriesID
                vc.season = season
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }
            return listTopicCell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.informationDetailTableViewCell) as? InformationDetailTableViewCell else {
                return UITableViewCell()
            }
            if let tvSeries = detailTVSeriesViewModel.tvSeries {
                cell.setupDataTVSeries(tvSeries: tvSeries)
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
                      let tvSeries = weakSelf.detailTVSeriesViewModel.tvSeries else { return }
                guard let vc = UIStoryboard(name: "ReviewViewController", bundle: nil).instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController else {
                    return
                }
                vc.tvSeries = tvSeries
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 && detailTVSeriesViewModel.cast?.isEmpty == true {
            return 74
        } else if indexPath.row == 4 {
            return 217
        } else if indexPath.row == 5 {
            if let sessionID = RealmManager.shared.currentUser?.sessionID,
               sessionID.isEmpty {
                return 35
            }
        }
        return UITableView.automaticDimension
    }
    
}

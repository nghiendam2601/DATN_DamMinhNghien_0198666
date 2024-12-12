//
//  DetailSeasonViewController.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 29/11/24.
//

import UIKit

class DetailSeasonViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var season: DetailSeasonModel?
    var tvSeriesID: Int?
    var detailSeasonViewModel = DetailSeasonViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup() {
        ["ActorDetailTableViewCell", Identifier.secondDetailTableViewCell, Identifier.listTopicTableViewCell, Identifier.informationDetailTableViewCell].forEach {
            registerTableView(tableView, identifier: $0)
        }
        let customHeader = CustomRefreshHeader()
        self.tableView.configRefreshHeader(with: customHeader, container: self) { [weak self] in
            AppConstant.isLoading = true
            self?.fetchData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
        setupViewModel()
    }
    
    @objc func languageDidChange() {
        fetchData()
    }
    
    func setupViewModel() {
        detailSeasonViewModel.onFetchDetailSeasonSuccess = { [weak self] in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.reloadData()
                weakSelf.title = weakSelf.detailSeasonViewModel.season?.name ?? ""
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        detailSeasonViewModel.onFetchDetailSeasonDataFailed = { [weak self] message in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.showAlert(title: LanguageDictionary.error.dictionary, message: message)
                weakSelf.tableView.switchRefreshHeader(to: .normal(.none, 0))
            }
        }
        fetchData()
    }
    
    func fetchData() {
        guard let tvSeriesID = tvSeriesID,
              let seasonNumber = season?.seasonNumber else { return }
        detailSeasonViewModel.fetchDetailSeasonData(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber)
    }
    
}

// MARK: - TableView
extension DetailSeasonViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActorDetailTableViewCell") as? ActorDetailTableViewCell else { return UITableViewCell() }
            cell.setupData(season: season)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondDetailTableViewCell") as? SecondDetailTableViewCell else { return UITableViewCell() }
            if let overview = season?.overview, !overview.isEmpty {
                cell.overViewLabel.text = overview
                cell.overViewLabel.textAlignment = .left
            } else {
                cell.overViewLabel.text = LanguageDictionary.noData.dictionary
                cell.overViewLabel.textAlignment = .center
            }
            cell.overViewTitle.text = LanguageDictionary.overview.dictionary
            return cell
        case 2:
            guard let listTopicCell = tableView.dequeueReusableCell(withIdentifier: "ListTopicTableViewCell", for: indexPath) as? ListTopicTableViewCell else {
                return UITableViewCell()
            }
            listTopicCell.episodeList = detailSeasonViewModel.season?.episodes
            listTopicCell.seeAll.isHidden = true
            listTopicCell.onTapDetail = { [weak self] episode in
                guard let weakSelf = self,
                      let episode = episode as? DetailEpisodeModel else { return }
                guard let vc = UIStoryboard(name: "DetailEpisodeViewController", bundle: nil).instantiateViewController(identifier: "DetailEpisodeViewController") as? DetailEpisodeViewController else { return }
                vc.episode = episode
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }
            return listTopicCell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.informationDetailTableViewCell) as? InformationDetailTableViewCell else {
                return UITableViewCell()
            }
            if let season = detailSeasonViewModel.season {
                cell.setupDataSeason(season: season)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 169
        } else {
            return UITableView.automaticDimension
        }
    }
    
}

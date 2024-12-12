//
//  DetailEpisodeViewController.swift
//  MovieInMinutes
//
//  Created by NghienDamMinh on 29/11/24.
//

import UIKit

class DetailEpisodeViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var episode: DetailEpisodeModel?
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ["ActorDetailTableViewCell", Identifier.secondDetailTableViewCell, Identifier.informationDetailTableViewCell].forEach {
            registerTableView(tableView, identifier: $0)
        }
        title = episode?.name ?? ""
        NotificationCenter.default.addObserver(self, selector: #selector(languageDidChange), name: .languageChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func languageDidChange(){
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView
extension DetailEpisodeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ActorDetailTableViewCell") as? ActorDetailTableViewCell else { return UITableViewCell() }
            cell.setupData(episode: episode)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondDetailTableViewCell") as? SecondDetailTableViewCell else { return UITableViewCell() }
            if let overView = episode?.overview, !overView.isEmpty {
                cell.overViewLabel.text = episode?.overview
                cell.overViewLabel.textAlignment = .left
            } else {
                cell.overViewLabel.text = LanguageDictionary.noData.dictionary
                cell.overViewLabel.textAlignment = .center
            }
            cell.overViewTitle.text = LanguageDictionary.overview.dictionary
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.informationDetailTableViewCell) as? InformationDetailTableViewCell else {
                return UITableViewCell()
            }
            if let episode = episode {
                cell.setupEpisode(episode: episode)
            }
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 169
        } else {
            return UITableView.automaticDimension
        }
    }
    
}


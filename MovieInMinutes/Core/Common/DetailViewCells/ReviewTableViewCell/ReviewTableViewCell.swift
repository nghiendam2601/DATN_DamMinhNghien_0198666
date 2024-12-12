//
//  ReviewTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 26/11/24.
//

import UIKit
import YouTubeiOSPlayerHelper

class ReviewTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var lblView: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var playerView: YTPlayerView!
    
    // MARK: - Properties
    var key: String? {
        didSet {
            if let key = key,
               !key.isEmpty {
                playerView.load(withVideoId: key)
            }
        }
    }
    
    // MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        playerView.delegate = self
    }
    
    // MARK: Setup methods
    func setupData(video: YoutubeVideoModel?) {
        guard let video = video else { return }
        lblTitle.text = video.title
        lblLike.text = "\(LanguageDictionary.like.dictionary): \(video.likeCount)"
        lblView.text = "\(LanguageDictionary.view.dictionary): \(video.viewCount)"
        key = video.videoID
    }
    
}

// MARK: - YTPlayer
extension ReviewTableViewCell: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("ok")
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print("Error loading video: \(error)")
    }
    
}

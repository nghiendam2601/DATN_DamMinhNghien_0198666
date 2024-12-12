//
//  FourthDetailTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 12/11/24.
//

import UIKit
import YouTubeiOSPlayerHelper

class FourthDetailTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var fourthDetailView: UIView!
    @IBOutlet weak var lblTrailer: UILabel!
    @IBOutlet var playerView: YTPlayerView!
    
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
        lblTrailer.text = LanguageDictionary.officialTrailer.dictionary
    }
    
}

// MARK: - YTPlayer
extension FourthDetailTableViewCell: YTPlayerViewDelegate {
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        print("ok")
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print("Error loading video: \(error)")
    }
    
}

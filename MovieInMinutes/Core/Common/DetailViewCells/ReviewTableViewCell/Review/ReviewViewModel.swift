//
//  ReviewViewModel.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 26/11/24.
//

import Foundation

class ReviewViewModel {
    
    // MARK: - Properties
    var onFetchSuccess: (() -> Void)?
    var onFetchFailed: ((String) -> Void)?
    var video: [YoutubeVideoModel]?
    
    // MARK: - Initialize
    init() {}
    
    // MARK: - Methods
    func fetchYouTubeVideo(keyword: String) {
        DispatchQueue.global().async { [weak self] in
            YoutubeVideoModel.fetchYouTubeVideoIds(keyword: keyword, apiKey: ScriptConstants.YtbApiKey) { success, videoIds, error in
                guard let weakSelf = self else { return }
                if success {
                    print("Video IDs: \(videoIds)")
                    weakSelf.video = []
                    let dispatchGroup = DispatchGroup()
                    for id in videoIds {
                        dispatchGroup.enter()
                        YoutubeVideoModel.fetchYouTubeVideoDetails(videoId: id, apiKey: ScriptConstants.YtbApiKey) { success, detail, error in
                            if success, let detail = detail {
                                weakSelf.video?.append(detail)
                            } else {
                                weakSelf.onFetchFailed?(error)
                            }
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        if let video = weakSelf.video, !video.isEmpty {
                            weakSelf.onFetchSuccess?()
                        } else {
                            weakSelf.onFetchFailed?("No videos were successfully fetched.")
                        }
                    }
                } else {
                    weakSelf.onFetchFailed?(error)
                }
            }
        }
    }
    
}

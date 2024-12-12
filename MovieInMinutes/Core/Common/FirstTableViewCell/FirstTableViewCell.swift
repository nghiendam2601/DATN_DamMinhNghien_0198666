//
//  FirstTableViewCell.swift
//  MovieInMinutes
//
//  Created by DamMinhNghien on 19/11/24.
//

import UIKit

class FirstTableViewCell: BaseTableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Properties
    var onSelectDetail: ((MovieModel) -> Void)?
    var onSelectDetailTV: ((TVSeriesModel) -> Void)?
    var movieList: [MovieModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
                self?.startAutoScroll()
                self?.updateInitialProgress()
            }
        }
    }
    var tvSeriesList: [TVSeriesModel]? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
                self?.startAutoScroll()
                self?.updateInitialProgress()
            }
        }
    }
    private var autoScrollTimer: Timer?
    private var isUserScrolling = false
    
    //MARK: - Nib
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView(collectionView, identifier: "TrendingCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: Methods
    private func updateInitialProgress() {
        let contentWidth = collectionView.contentSize.width
        let visibleWidth = collectionView.bounds.width
        let offsetX = collectionView.contentOffset.x
        // Tính toán progress ban đầu
        let progress = contentWidth > 0 ? max(0, min(1, (offsetX + visibleWidth) / contentWidth)) : 0
        // Cập nhật UIProgressView
        progressView.progress = Float(progress)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopAutoScroll()
    }
    
    private func startAutoScroll() {
        stopAutoScroll()
        guard autoScrollTimer == nil else { return }
        
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isUserScrolling else { return }
            self.scrollToNextItem()
        }
        RunLoop.main.add(autoScrollTimer!, forMode: .common)
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    private func scrollToNextItem() {
        let currentListCount = movieList?.count ?? tvSeriesList?.count ?? 0
        guard currentListCount > 0 else { return }
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems
        guard let currentIndexPath = visibleIndexPaths.sorted(by: { $0.row < $1.row }).first else { return }
        let nextIndex = currentIndexPath.row + 1
        
        if nextIndex < currentListCount {
            let nextIndexPath = IndexPath(item: nextIndex, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        } else {
            // Scroll back to the first item
            let firstIndexPath = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

//MARK: - CollectionView
extension FirstTableViewCell {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movieList = movieList {
            return movieList.count
        } else if let tvSeriesList = tvSeriesList {
            return tvSeriesList.count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionViewCell", for: indexPath) as? TrendingCollectionViewCell else { return UICollectionViewCell() }
        if let movieList = movieList {
            cell.name.text = movieList[indexPath.row].title
            let backdropBaseURL = ScriptConstants.imageUrlW1280
            let fullBackDropPath = backdropBaseURL + (movieList[indexPath.row].backdropPath)
            ImageLoader.loadImage(for: cell.img, from: fullBackDropPath)
        } else if let tvSeriesList = tvSeriesList {
            cell.name.text = tvSeriesList[indexPath.row].name
            let backdropBaseURL = ScriptConstants.imageUrlW1280
            let fullBackDropPath = backdropBaseURL + (tvSeriesList[indexPath.row].backdropPath)
            ImageLoader.loadImage(for: cell.img, from: fullBackDropPath)
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieList = movieList {
            onSelectDetail?(movieList[indexPath.row])
        } else if let tvSeriesList = tvSeriesList {
            onSelectDetailTV?(tvSeriesList[indexPath.row])
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    //MARK: ScrollView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isUserScrolling = false
            startAutoScroll()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserScrolling = false
        startAutoScroll()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let contentWidth = collectionView.contentSize.width
        let visibleWidth = collectionView.bounds.width
        let offsetX = collectionView.contentOffset.x
        // Tính toán progress (giá trị từ 0.0 đến 1.0)
        let progress = max(0, min(1, (offsetX + visibleWidth) / contentWidth))
        // Cập nhật UIProgressView
        progressView.progress = Float(progress)
    }
    
}

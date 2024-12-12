import UIKit
import PullToRefreshKit
import NVActivityIndicatorView

class CustomRefreshHeader: UIView, RefreshableHeader {
//    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    let activityIndicator = NVActivityIndicatorView(
        frame: CGRect(x: 0, y: 0, width: 40, height: 40),
        type: .circleStrokeSpin,
        color: .red,
        padding: 5
    )
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    // MARK: - RefreshableHeader
    func heightForHeader() -> CGFloat {
        return 50
    }

    func percentUpdateDuringScrolling(_ percent: CGFloat) {
        // Không cần cập nhật gì khi kéo
    }

    func didBeginRefreshingState() {
        activityIndicator.startAnimating() // Khi bắt đầu trạng thái refresh
    }

    func didBeginHideAnimation(_ result: RefreshResult) {
        // Có thể thêm hiệu ứng khi header bắt đầu ẩn
    }

    func didCompleteHideAnimation(_ result: RefreshResult) {
        activityIndicator.stopAnimating() // Khi hoàn tất ẩn header
    }
}

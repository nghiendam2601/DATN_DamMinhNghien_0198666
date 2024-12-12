import Foundation
import UIKit
import Kingfisher

class ImageLoader {
    
    @MainActor
    static func loadImage(for imageView: UIImageView, from fullImagePath: String, cornerRadius: CGFloat = 10) {
        guard let imageURL = URL(string: fullImagePath) else {
            print("Invalid URL")
            return
        }
        
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "placeHolder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        ) { result in
            switch result {
            case .success(_):
                break
                //                print("Image loaded successfully")
            case .failure(_):
                return
                //                print("Failed to load image: \(error.localizedDescription)")
            }
        }
    }
    
}

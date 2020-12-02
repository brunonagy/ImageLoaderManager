import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func loadImageFrom(urlString: String) {
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        image = nil
        
        guard let imageUrl = URL(string: urlString) else {
            self.backgroundColor = .clear
            return
        }
        
        if let imageFromCache = imageCache.object(forKey: imageUrl as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }
        
        activityIndicator.removeFromSuperview()
        activityIndicator.square(20)
        addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                
                guard let image = UIImage(data: data ?? Data()) else {
                    self?.backgroundColor = .clear
                    activityIndicator.removeFromSuperview()
                    return
                }
                
                imageCache.setObject(image, forKey: imageUrl as AnyObject)
                self?.image = image
                activityIndicator.removeFromSuperview()
                return
                
            }
        }.resume()
    }
}

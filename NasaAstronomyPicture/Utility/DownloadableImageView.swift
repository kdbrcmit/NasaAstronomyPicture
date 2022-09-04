//
//  DownloadableImageView.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 04/09/22.
//

import UIKit

class DownloadableImageView: UIImageView {
    var imageDownloadSession: URLSessionDataTask?
    
    /// Function to download and save the image in Document directory
    func downloaded(from link: String, completion: @escaping () -> Void) {
        imageDownloadSession?.cancel()
        guard let url = URL(string: link) else {
            Logger.e("wrong_image_url".localized)
            return
        }
        
        contentMode = .scaleAspectFit
        if FileManager.default.fileExists(atPath: url.documentURL.path) {
            self.image = loadImageFromDocumentDirectory(url: url)
            completion()
        } else {
            imageDownloadSession = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else { return }
                try? data.write(to: url.documentURL)
                
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                    self?.contentMode = .scaleAspectFit
                    completion()
                }
            }
            imageDownloadSession?.resume()
        }
    }
    
    /// Used to resize the imageview based on image
    open override var intrinsicContentSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
    /// Function to load the image from document directory
    private func loadImageFromDocumentDirectory(url: URL) -> UIImage? {
        if FileManager.default.fileExists(atPath: url.documentURL.path) {
            let image = UIImage(contentsOfFile: url.documentURL.path)
            return image
        }
        return nil
    }
}

//
//  UIImage+View+DownloadImage.swift
//  StoreSearch
//
//  Created by Tahlia Callegari on 10/3/20.
//

import UIKit

extension UIImageView {
  func loadImage(url: URL) -> URLSessionDownloadTask {
    let session = URLSession.shared
    let downloadTask = session.downloadTask(with: url, completionHandler: { [weak self] url, response, error in
      if error == nil, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
        DispatchQueue.main.async {
          if let weakSelf = self {
            weakSelf.image = image
          }
        }
      }
    })
    downloadTask.resume()
    return downloadTask
  }
}


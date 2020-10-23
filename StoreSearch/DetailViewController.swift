//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Tahlia Callegari on 10/3/20.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    var searchResult: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    var dismissStyle = AnimationStyle.fade

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        popupView.layer.cornerRadius = 10
        
        let gestureRecongizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecongizer.cancelsTouchesInView = false
        gestureRecongizer.delegate = self
        view.addGestureRecognizer(gestureRecongizer)
        
        if searchResult != nil {
            updateUI()
        }
        view.backgroundColor = UIColor.clear
    }
    
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
    
    enum AnimationStyle{
        case slide
        case fade
    }
    
    
    // MARK: - Actions
    @IBAction func close() {
        dismissStyle = .slide
        dismiss(animated: true, completion: nil)
    }
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //MARK:- Helper Methods
    func updateUI() {
        nameLabel.text = searchResult.name
        
        if searchResult.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        }else {
            artistNameLabel.text = searchResult.artist
        }
        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre
   
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = searchResult.currency
    
    let priceText: String
    if searchResult.price == 0 {
        priceText = "Free"
    }else if let text = formatter.string(from: searchResult.price as NSNumber) {
        priceText = text
    }else{
        priceText = ""
    }
    priceButton.setTitle(priceText, for: .normal)

        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
    }
}
extension DetailViewController: UIViewControllerTransitioningDelegate {
  func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
  }
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      return BounceAnimationController()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch dismissStyle {
    case .slide:
        return SlideOutAnimationController()
    case .fade:
        return FadeOutAnimationController()
    }
  }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}

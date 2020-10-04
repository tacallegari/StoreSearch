//
//  DimmmingPresentationController.swift
//  StoreSearch
//
//  Created by Tahlia Callegari on 10/3/20.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool {
        return false
    }
}

extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController( presentedViewController: presented, presenting: presenting)
    }
}

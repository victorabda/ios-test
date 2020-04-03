//
//  GalleryVC.swift
//  TestShareRH
//
//  Created by Victor B D Almeida on 02/04/20.
//  Copyright © 2020 Victor B D Almeida. All rights reserved.
//

import UIKit

class GalleryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSearch: UIButton!
    
    var allImages = [String]()
    var isAllDataLoaded = false
    var isNewDataLoading = false
    var actualPage = 0
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        updateGallery(page: 0, text: "cats")
    }
    
    func configureCollectionView() {
        collectionView.register(UINib(nibName: CCellGallery.nibIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: CCellGallery.nibIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func updateGallery(page: Int, text: String?) {
        guard isAllDataLoaded == false, isNewDataLoading == false, actualPage < 2 else {
            return
        }
        
        isNewDataLoading = true
        APIClient.getGallery(page: page, text: text) { (gallery) in
            self.isNewDataLoading = false

            let parsedImages = APIClient.parseAllImages(data: gallery)
            if parsedImages.count == 0 {
                self.isAllDataLoaded = true
            } else {
                self.actualPage += 1
                if self.actualPage <= 1 {
                    self.allImages = parsedImages
                } else {
                    self.allImages += parsedImages
                }
            }
            
            DispatchQueue.main.async {
                if text != "cats" {
                    self.isAllDataLoaded = true
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    
    // MARK: - Search
    @IBAction func btnSearchClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Search Imgur", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            guard let text = textField?.text, text.count > 0 else {
                return
            }
            self.allImages = []
            self.isAllDataLoaded = false
            self.actualPage = 0
            self.collectionView.reloadData()
            self.updateGallery(page: 0, text: text)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}


//
//  GalleryVC+Extensions.swift
//  TestShareRH
//
//  Created by Victor B D Almeida on 03/04/20.
//  Copyright © 2020 Victor B D Almeida. All rights reserved.
//

import UIKit
import Lightbox

// MARK: - <CollectionView>
extension GalleryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CCellGallery.nibIdentifier, for: indexPath) as? CCellGallery else {
            return UICollectionViewCell()
        }
        cell.configure(link: self.allImages[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == allImages.count - 1 {
            updateGallery(page: actualPage+1, text: "cats")
        }
    }
}


// MARK: - Cell delegate
extension GalleryVC: GalleryCellDelegate, LightboxControllerDismissalDelegate {
    
    func imageClicked(link: String, image: UIImage?) {
        guard let url = URL(string: link) else {
            return
        }
        
        var images = [LightboxImage]()
        if link.fileExtension() == "mp4" {
            images.append(LightboxImage(image: UIImage(named: "movie")!, text: "", videoURL: url))
        } else if let image = image {
            images.append(LightboxImage(image: image))
        } else {
            images.append(LightboxImage(imageURL: url))
        }
        
        let controller = LightboxController(images: images, startIndex: 0)
        controller.dismissalDelegate = self
        controller.dynamicBackground = true
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }

    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        navigationController?.popViewController(animated: true)
    }
}

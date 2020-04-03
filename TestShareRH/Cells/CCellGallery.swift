//
//  CCellGallery.swift
//  TestShareRH
//
//  Created by Victor B D Almeida on 02/04/20.
//  Copyright © 2020 Victor B D Almeida. All rights reserved.
//

import UIKit
import Kingfisher

protocol GalleryCellDelegate: class {
    func imageClicked(link: String, image: UIImage?)
}

class CCellGallery: UICollectionViewCell {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var btnAction: UIButton!
    
    static let nibIdentifier = "CCellGallery"
    var delegate: GalleryCellDelegate?
    var link = ""

    
    // MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBg.layer.cornerRadius = 4
        viewBg.layer.shadowOffset = CGSize(width: 0, height: 2)
        viewBg.layer.shadowRadius = 0.2
        viewBg.layer.shadowOpacity = 0.5
        viewBg.layer.shadowColor = UIColor.white.cgColor
    }
    
    func configure(link: String) {
        self.link = link
        
        switch link.fileExtension() {
        case "gif":
            viewBg.backgroundColor = .clear
            let fname = "\(link.fileName()).\(link.fileExtension())"
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsPath.appendingPathComponent(fname)
            do {
                imgPhoto.kf.indicatorType = .none
                let data = try Data(contentsOf: fileURL)
                self.imgPhoto.loadGif(data: data)
                break
            } catch {
                // print(error.localizedDescription)
                print("gif file not found")
            }
            
            imgPhoto.kf.indicatorType = .activity
            if let url = URL(string: link) {
                let queue = OperationQueue()
                queue.maxConcurrentOperationCount = 1
                
                let operation = DownloadOperation(session: URLSession.shared, downloadTaskURL: url, completionHandler: { (localURL, response, error, originalUrl) in
                    print("finished downloading \(url.absoluteString)")
                    
                    guard let localURL = localURL else {
                        return
                    }
                    
                    let destinationURL = documentsPath.appendingPathComponent(fname)
                    // delete original copy
                    try? FileManager.default.removeItem(at: destinationURL)
                    // copy from temp to Document
                    do {
                        try FileManager.default.copyItem(at: localURL, to: destinationURL)
                    } catch let error {
                        print("Copy Error: \(error.localizedDescription)")
                    }
                })
                queue.addOperation(operation)
            }
        case "jpg", "png", "jpeg":
            viewBg.backgroundColor = .clear
            if let url = URL(string: link) {
                imgPhoto.kf.indicatorType = .activity
                imgPhoto.kf.setImage(with: url)
            }
        case "mp4":
            imgPhoto.kf.indicatorType = .none
            imgPhoto.image = UIImage(named: "movie-w")
            viewBg.backgroundColor = UIColor(red:0.17, green:0.18, blue:0.20, alpha:1.00)
        default:
            break
        }
        
        imgPhoto.layer.cornerRadius = 4
    }

    
    // MARK: - Actions
    @IBAction func btnActionClick(_ sender: UIButton) {
        delegate?.imageClicked(link: self.link, image: imgPhoto.image)
    }
    
}

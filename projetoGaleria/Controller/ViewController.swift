//
//  ViewController.swift
//  projetoGaleria
//
//  Created by Bruno Rocha on 16/04/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private let service: GallerySearchService

    private let cellSpacing: CGFloat = 1
    private let columns: CGFloat = 4
    private var cellSize: CGFloat?

    var arrayOfImages: [String] = []
    var currentPage = 1

    init() {
        self.service = GallerySearchService()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.service = GallerySearchService()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        loadGallery()
    }

    private func loadGallery() {
        service.getImages(search: "dogs", page: currentPage) { [weak self] response in
            let allImages = response.data.compactMap {
                $0.images?.compactMap { $0.link }
            }.flatMap { images in
                return images
            }

            DispatchQueue.main.async {
                self?.arrayOfImages.append(contentsOf: allImages)
                self?.collectionView.reloadData()
                self?.currentPage += 1
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        
        cell.display(image: nil)
        
        let link = arrayOfImages[indexPath.row]
        service.downloadImage(with: link) { image in
            DispatchQueue.main.async {
                
                cell.imageCell.image = image
                cell.imageCell.contentMode = .scaleAspectFill
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == arrayOfImages.count - 4 {
            loadGallery()
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellSize == nil {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout
            let emptySpace = layout.sectionInset.left + layout.sectionInset.right + (columns * cellSpacing - 1)
            cellSize = (view.frame.size.width - emptySpace) / columns
        }

        return CGSize(width: cellSize!, height: cellSize!)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}

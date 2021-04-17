//
//  ViewController.swift
//  projetoGaleria
//
//  Created by Bruno Rocha on 16/04/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let galleryFlowLayout = GalleryFlowLayout(
        cellsPerRow: 4,
        minimumInteritemSpacing: 10,
        minimumLineSpacing: 10,
        sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = galleryFlowLayout
    }
    
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imgCell", for: indexPath) as! ImageCell
        let url = URL(string: "https://images.dog.ceo/breeds/otterhound/n02091635_215.jpg")!
        let data = try! Data(contentsOf: url)
        cell.imageCell.image = UIImage(data: data)
        return cell
    }
    
    
    
}

extension ViewController: UICollectionViewDelegate {
    
    
}

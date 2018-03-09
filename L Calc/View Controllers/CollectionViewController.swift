//
//  CollectionViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 21.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//
// https://designcode.io/swift4-collection-view

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var chapterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chapterCollectionView.delegate = self
        chapterCollectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //MARK: animation https://www.raywenderlich.com/173544/ios-animation-tutorial-getting-started-3
        chapterCollectionView.center.x -= view.bounds.width
        chapterCollectionView.alpha = 0.1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //MARK: animation https://www.raywenderlich.com/173544/ios-animation-tutorial-getting-started-3
        UIView.animate(withDuration: 0.5,
                       delay: 0.15,
                       options: [.curveEaseOut, .transitionCrossDissolve],
                       animations: {
                           self.chapterCollectionView.center.x += self.view.bounds.width
                           self.chapterCollectionView.alpha = 1
                       },
                       completion: nil
        )
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "sectionCell",
            for: indexPath) as! SectionCollectionViewCell
        
        let section = sections[indexPath.row]
        cell.titleLabel.text = section["title"]
        cell.coverImageView.image = UIImage(named: section["image"]!)
        
        return cell
    }
}

extension CollectionViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Cover Image Parallax from
        // https://designcode.io/swift4-3d-animation
        // using just for Collection View
        
        if let collectionView = scrollView as? UICollectionView {
            for cell in collectionView.visibleCells as! [SectionCollectionViewCell] {
                let indexPath = collectionView.indexPath(for: cell)!
                let attributes = collectionView.layoutAttributesForItem(at: indexPath)!
                let cellFrame = collectionView.convert(attributes.frame, to: view)
                
                let translationX = cellFrame.origin.x / 3
                cell.coverImageView.transform = CGAffineTransform(translationX: translationX, y: 0)
                
//                cell.layer.transform = animateCell(cellFrame: cellFrame)
            }
        }
    }
    
    func animateCell(cellFrame: CGRect) -> CATransform3D {
        // CATransform3D Rotate
        // from https://designcode.io/swift4-3d-animation
        
        let angleFromX = Double((-cellFrame.origin.x) / 15)
        let angle = CGFloat((angleFromX * Double.pi) / 180.0)
        var transform = CATransform3DIdentity
        transform.m34 = -1.0/1000
        let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
        
        var scaleFromX = (1000 - (cellFrame.origin.x - 200)) / 1000
        let scaleMax: CGFloat = 1.0
        let scaleMin: CGFloat = 0.6
        if scaleFromX > scaleMax {
            scaleFromX = scaleMax
        }
        if scaleFromX < scaleMin {
            scaleFromX = scaleMin
        }
        let scale = CATransform3DScale(
            CATransform3DIdentity, scaleFromX, scaleFromX, 1)
        
        return CATransform3DConcat(rotation, scale)
    }

}

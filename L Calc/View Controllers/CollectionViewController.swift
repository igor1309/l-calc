//
//  CollectionViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 21.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var chapterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chapterCollectionView.delegate = self
        chapterCollectionView.dataSource = self
    }

}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "sectionCell",
            for: indexPath)
        return cell
    }
    
    
}

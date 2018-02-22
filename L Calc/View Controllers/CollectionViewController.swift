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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // MARK: animation
        chapterCollectionView.center.x -= view.bounds.width
        chapterCollectionView.alpha = 0.1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // MARK: animation
        UIView.animate(withDuration: 0.5,
                       delay: 0.25,
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "sectionCell",
            for: indexPath)
        return cell
    }
    
    
}

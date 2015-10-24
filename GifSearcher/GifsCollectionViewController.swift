//
//  GifsCollectionViewController.swift
//  GifSearcher
//
//  Created by Giorgia Marenda on 10/23/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import UIKit

let reuseCollectionViewCellIdentifier = "CollectionViewCell"

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
}

class GifsCollectionViewController: UICollectionViewController {

    var gifs = [Gif]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GiphyAPI.trendingGIFs { (result: [Gif]?, error: ErrorType?) -> Void in
            if let values = result, collectionView = self.collectionView {
                self.gifs = values
                collectionView.reloadData()
            }
        }
    
    }
    
    // MARK: - Collection view data source
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseCollectionViewCellIdentifier, forIndexPath: indexPath)
        
        return cell
    }
    
    
}

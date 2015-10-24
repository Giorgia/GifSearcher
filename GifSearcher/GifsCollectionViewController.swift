//
//  GifsCollectionViewController.swift
//  GifSearcher
//
//  Created by Giorgia Marenda on 10/23/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import UIKit
import AlamofireImage
import AnimatedGIFImageSerialization

let reuseCollectionViewCellIdentifier = "CollectionViewCell"

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCellWithURLString(URLString: String) {
        print(URLString)
        imageView.af_setImageWithURL( NSURL(string: URLString)!,
            imageTransition: .CrossDissolve(0.2))
    }
    
    override func prepareForReuse() {
        imageView.af_cancelImageRequest()
        imageView.layer.removeAllAnimations()
        imageView.image = nil
    }
}

class GifsCollectionViewController: UICollectionViewController {

    var gifs = [Gif]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GiphyAPI.search("funny") { (result: [Gif]?, error: ErrorType?) -> Void in
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

        guard   let gifCell = cell as? GifCell,
                let gifUrl  = gifs[indexPath.row].images?.fixedHeightSmall?.url
                else { return cell }
        
        gifCell.configureCellWithURLString(gifUrl)
        
        return gifCell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let dim             = collectionView.bounds.size.width - (collectionView.layoutMargins.left * 4)
        let targetSize      = CGSize(width: dim / 3, height: dim / 3)
        
        return targetSize
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailSegue") {
            
            guard   let indexPath   = collectionView?.indexPathsForSelectedItems()?.first,
                    let cell        = collectionView?.cellForItemAtIndexPath(indexPath) as? GifCell,
                    let detail      = segue.destinationViewController as? GifDetailViewController
                    else { return }
            
            let gif             = gifs[indexPath.row]
            detail.gif          = gif
            detail.shareData    = UIImageAnimatedGIFRepresentation(cell.imageView.image)
        }
    }
}

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

let reuseCollectionViewCellIdentifier   = "CollectionViewCell"
let reuseCollectionViewHeaderIdentifier = "CollectionViewHeader"

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configureCellWithURLString(URLString: String) {
        imageView.af_setImageWithURL( NSURL(string: URLString)!,
            imageTransition: .CrossDissolve(0.2))
    }
    
    override func prepareForReuse() {
        imageView.af_cancelImageRequest()
        imageView.layer.removeAllAnimations()
        imageView.image = nil
    }
}

class HeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
}

class GifsCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var gifs = [Gif]()
    let searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        
        loadGifs(nil)
    }
    
    func reloadData(result: [Gif]?, error: ErrorType?) {
        if let values = result, collectionView = collectionView {
            self.gifs = values
            collectionView.reloadData()
        }
    }
    
    func loadGifs(query: String?) {
        if let searchQuery = query {
            GiphyAPI.search(searchQuery, complention: reloadData)
        } else {
            GiphyAPI.trendingGIFs(reloadData)
        }
    }
    
    // MARK: - Collection view data source
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: reuseCollectionViewHeaderIdentifier, forIndexPath: indexPath)
        if let titleHeader = header as? HeaderView {
            if let searchQuery = searchBar.text where searchBar.text != "" {
                titleHeader.titleLabel.text = "Results for " + searchQuery
            } else {
                titleHeader.titleLabel.text = "Trending GIFs"
            }
            return titleHeader
        }
        return header
    }
    
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
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        collectionView?.performBatchUpdates(nil, completion: nil)
    }
    
    // MARK: - Search delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        loadGifs(searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        loadGifs(nil)
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "detailSegue") {
            
            guard let indexPath = collectionView?.indexPathsForSelectedItems()?.first,
                let cell        = collectionView?.cellForItemAtIndexPath(indexPath) as? GifCell,
                let detail      = segue.destinationViewController as? GifDetailViewController
                else { return }
            
            let gif             = gifs[indexPath.row]
            detail.gif          = gif
            detail.shareData    = UIImageAnimatedGIFRepresentation(cell.imageView.image)
        }
    }
    
}

//
//  ImageCell.swift
//  SmagaExample
//
//  Created by grzesiek on 25/11/2016.
//  Copyright © 2016 Mateusz Mirkowski. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
  @IBOutlet weak var imageView: UIImageView!
  
  func configureCell(data: Image) {
    print("configure cell")
//    self.imageView.image = UIImage(data: NSData(contentsOf: NSURL(string:data.imageURL)! as URL)! as Data)!
    getDataFromUrl(urlString: data.imageURL) { (data, response, error)  in
      guard let data = data, error == nil else { return }
      print("Download Finished")
      DispatchQueue.main.async() { () -> Void in
        let image = UIImage(data: data)
      
        self.imageView.image = image
        
      }
    }
  }
}


func getDataFromUrl(urlString: String, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
  let url = URL(string: urlString)
  URLSession.shared.dataTask(with: url!) {
    (data, response, error) in
    completion(data, response, error)
    }.resume()
}
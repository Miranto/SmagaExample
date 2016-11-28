//
//  ViewController.swift
//  SmagaExample
//
//  Created by grzesiek on 25/11/2016.
//  Copyright © 2016 Mateusz Mirkowski. All rights reserved.
//

import UIKit
import Moya
import Moya_ObjectMapper

class ViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var imagesCollectionView: UICollectionView!
  fileprivate let reuseIdentifier = "ImageCell"
  var imagesData = [Image](){
    didSet {
      print(imagesData.count)
    }
  }
  
  var root = [Root]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let provider = MoyaProvider<DataApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    print("lala")
    
    provider.request(.imagesList, completion: { result in
      
      switch result {
      case let .success(response):
        do {
          let root: Root? = try response.mapObject(Root.self)
          self.imagesData = (root?.images)!
 
        } catch {
          print("catch")
          
        }
        self.imagesCollectionView.reloadData()
      case let .failure(error):
        guard let error = error as? CustomStringConvertible else {
          break
        }
       
      }
      
    })
  }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return self.imagesData.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                  for: indexPath) as! ImageCell
    
    cell.configureCell(data: self.imagesData[indexPath.row])
    return cell
  }
}


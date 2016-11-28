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
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongGesture:")
    longPressGesture.delegate = self
    self.imagesCollectionView.addGestureRecognizer(longPressGesture)
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let provider = MoyaProvider<DataApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
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
        guard error is CustomStringConvertible else {
          break
        }
       
      }
      
    })
  }
}

// MARK: - UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
  func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
    
    switch(gesture.state) {
      
    case UIGestureRecognizerState.began:
      guard let selectedIndexPath = self.imagesCollectionView.indexPathForItem(at: gesture.location(in: self.imagesCollectionView)) else {
        break
      }
      imagesCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
    case UIGestureRecognizerState.changed:
      imagesCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
    case UIGestureRecognizerState.ended:
      imagesCollectionView.endInteractiveMovement()
    default:
      imagesCollectionView.cancelInteractiveMovement()
    }
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

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      moveItemAt sourceIndexPath: IndexPath,
                      to destinationIndexPath: IndexPath) {
    let temp = self.imagesData[sourceIndexPath.row]
    self.imagesData[sourceIndexPath.row] = self.imagesData[destinationIndexPath.row]
    self.imagesData[destinationIndexPath.row] = temp
  }
}




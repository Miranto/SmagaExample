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
import SwiftSpinner

class ViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet weak var imagesCollectionView: UICollectionView!
  fileprivate let reuseIdentifier = "ImageCell"
  fileprivate var imagesData = [Image]() {
    didSet {
      print("images count ", imagesData.count)
    }
  }
  
  // MARK: - Lifecycles Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.handleLongGesture(_:)))
    longPressGesture.delegate = self
    self.imagesCollectionView.addGestureRecognizer(longPressGesture)
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.downloadImages()
  }
  
  // MARK: Setup Views Methods
  
  func setupView() {
    self.view.backgroundColor = UIColor(hex: 0xFB8C00 )
    self.imagesCollectionView.backgroundColor = UIColor.clear
  }
  
  // MARK: Networking Methods
  
  func downloadImages() {
    let provider = MoyaProvider<DataApi>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    SwiftSpinner.show("Loading data...")
    provider.request(.imagesList, completion: { result in
      
      switch result {
      case let .success(response):
        do {
          let root: Root? = try response.mapObject(Root.self)
          self.imagesData = (root?.images)!
          SwiftSpinner.hide()
          
        } catch {
          SwiftSpinner.hide()
          self.showErrorAlert()
          
        }
        self.imagesCollectionView.reloadData()
      case let .failure(error):
        SwiftSpinner.hide()
        self.showErrorAlert()
        
        guard error is CustomStringConvertible else {
          break
        }
      }
    })
  }
  
  // MARK: Helpers Methods

  func showErrorAlert() {
    let alertController = UIAlertController(title: "Error", message: "Cannot download data. Please try again later.", preferredStyle: .alert)
    
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func showTimestampAlert(info: Info) {
    let timestampMessage = self.convertDateToHumanReadableForm(stringDate: info.timestamp)
    let alertController = UIAlertController(title: "Timestamp", message: timestampMessage, preferredStyle: .alert)
    
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  func convertDateToHumanReadableForm(stringDate: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    let date = dateFormatter.date(from: stringDate)
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    let convertedDate = dateFormatter.string(from: date!)
    
    return convertedDate
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
                      didDeselectItemAt indexPath: IndexPath) {
    let info = self.imagesData[indexPath.row].info
    
    self.showTimestampAlert(info: info!)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      moveItemAt sourceIndexPath: IndexPath,
                      to destinationIndexPath: IndexPath) {
    let temp = self.imagesData[sourceIndexPath.row]
    self.imagesData[sourceIndexPath.row] = self.imagesData[destinationIndexPath.row]
    self.imagesData[destinationIndexPath.row] = temp
  }
}




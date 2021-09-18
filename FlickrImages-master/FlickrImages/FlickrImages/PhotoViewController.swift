//
//  PhotoViewController.swift
//  FlickrImage
//
//  Created by Vicky Kuo on 2019/11/29.
//  Copyright © 2019 Vicky Kuo. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

  @IBOutlet weak var photoImageView: UIImageView!
  var photo: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    photoImageView.image = photo
  }
}

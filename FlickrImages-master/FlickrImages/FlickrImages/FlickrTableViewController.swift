//
//  ViewController.swift
//  FlickrImage
//
//  Created by Vicky Kuo on 2019/11/24.
//  Copyright © 2019 Vicky Kuo. All rights reserved.
//

import UIKit

class FlickrTableViewController: UITableViewController {
    
    var photos: [FlickrPhoto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFlickrImage()
    }
    
    //set how many sections of tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func loadFlickrImage(){
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1")!
        let configuration = URLSessionConfiguration.ephemeral
        
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: url) {
            (data, response, Error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data
                else{
                    return
            }
            do {
                let decoder = JSONDecoder()
                let media = try decoder.decode(FlickerJSON.self, from: data)
                for item in media.items {
                    if let imageURL = item.media["m"]{
                        let url = URL(string: imageURL)!
                        let imageData = try Data(contentsOf: url)
                        if let image = UIImage(data: imageData){
                            let flickrImage = FlickrPhoto(image: image, title: item.title)
                            self.photos.append(flickrImage)
                        }
                    }
                }
                let queue = OperationQueue.main
                queue.addOperation {
                    self.tableView.reloadData()
                }
            }
            catch {
                print("Error info: \(error)")
            }
        }
        task.resume()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FlickrCell", for: indexPath)
        cell.imageView?.image = photos[indexPath.row].image
        cell.textLabel?.text = photos[indexPath.row].title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoSegue" {
            guard let cell = sender as? UITableViewCell, let
                photoViewController = segue.destination as? PhotoViewController, let indexPath = tableView.indexPath(for: cell) else{
                    return
            }
            let flickrPhoto = photos[indexPath.row]
            photoViewController.photo = flickrPhoto.image
        }
    }
   
}


struct FlickerJSON: Codable{
    struct FlickrItem: Codable{
        let media: Dictionary<String, String>
        let title: String
    }
    let items: [FlickrItem]
}

struct  FlickrPhoto {
    let image: UIImage
    let title: String
}

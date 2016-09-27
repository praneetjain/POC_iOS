//
//  ViewController.swift
//  BookDisplay
//
//  Created by Praneet Jain on 5/30/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {

    var books = [Book]()
    
    var dataTask : URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cell = UINib(nibName: BookTableViewIdentifiers.bookCell, bundle: Bundle.main)
        tableView.register(cell, forCellReuseIdentifier: BookTableViewIdentifiers.bookCell)
        tableView.rowHeight = 80
        
        fetchDataFromURL()
    }
    
    
    func fetchDataFromURL(){
    
    
        let stringURL = "https://www.googleapis.com/books/v1/volumes?q=Harry%20Potter%20Azkaban"
        let url = URL(string: stringURL)
        
        let session = URLSession.shared
        
        if let url = url{
        
         dataTask = session.dataTask(with: url, completionHandler: { data, response, error in
            
            if let data = data, let dictionary = self.parseJSON(data){
            
                self.books = self.parseDictionary(dictionary)
                
                DispatchQueue.main.async{
                
                    self.tableView.reloadData()
                }
               return
            }
            else{
            
                print("Failed to parse data: \(response)")
                
            }
            
            self.tableView.reloadData()
            self.showDataFetchFailError()
            }) 
        }
        
        dataTask?.resume()
    
    }
    
    
    func parseJSON(_ data : Data) -> [String : AnyObject]?{
    
        do{
        
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
        }
        catch{
        
            print("JSON parsing failed")
            return nil
        }
    }
    

    func parseDictionary(_ dictionary : [String : AnyObject]) -> [Book]{
        
        guard let array = dictionary["items"] as? [AnyObject] else{
            
            print("parseDictionary failed")
            return []
        }
        
        var books = [Book]()
        for bookDict in array {
            
            if let bookDict = bookDict as? [String : AnyObject]{
                
                let book = Book()
                
                if let volumeDict = bookDict["volumeInfo"] as? [String : AnyObject], let title = volumeDict["title"] as? String{
                    
                    book.bookName =  title
                    
                    if let imageLinks = volumeDict["imageLinks"] as? [String : AnyObject], let imageURL = imageLinks["smallThumbnail"] as? String{
                        
                        book.bookSmallThumbnailURL = imageURL
                        
                    }
                    
                }
                books.append(book)
                
            }
            
        }
        
        return books
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewIdentifiers.bookCell, for: indexPath) as! BookCell
        
        cell.configureCell(books[(indexPath as NSIndexPath).row])
        
        return cell
    }
    
    struct BookTableViewIdentifiers{
    
        static let bookCell = "BookCell"
    
    }

func showDataFetchFailError(){
    
    let alertController = UIAlertController(title: "Whoops...", message: "There was error in fetching data from server. Please try again.", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    
    alertController.addAction(action)
    present(alertController, animated: true, completion: nil)
    
}

    deinit{
    dataTask?.cancel()
    }

}

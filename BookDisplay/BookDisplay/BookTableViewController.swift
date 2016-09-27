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
    
    var dataTask : NSURLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cell = UINib(nibName: BookTableViewIdentifiers.bookCell, bundle: NSBundle.mainBundle())
        tableView.registerNib(cell, forCellReuseIdentifier: BookTableViewIdentifiers.bookCell)
        tableView.rowHeight = 80
        
        fetchDataFromURL()
    }
    
    
    func fetchDataFromURL(){
    
    
        let stringURL = "https://www.googleapis.com/books/v1/volumes?q=Harry%20Potter%20Azkaban"
        let url = NSURL(string: stringURL)
        
        let session = NSURLSession.sharedSession()
        
        if let url = url{
        
         dataTask = session.dataTaskWithURL(url) { data, response, error in
            
            if let data = data, dictionary = self.parseJSON(data){
            
                self.books = self.parseDictionary(dictionary)
                
                dispatch_async(dispatch_get_main_queue()){
                
                    self.tableView.reloadData()
                }
               return
            }
            else{
            
                print("Failed to parse data: \(response)")
                
            }
            
            self.tableView.reloadData()
            self.showDataFetchFailError()
            }
        }
        
        dataTask?.resume()
    
    }
    
    
    func parseJSON(data : NSData) -> [String : AnyObject]?{
    
        do{
        
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : AnyObject]
        }
        catch{
        
            print("JSON parsing failed")
            return nil
        }
    }
    

    func parseDictionary(dictionary : [String : AnyObject]) -> [Book]{
        
        guard let array = dictionary["items"] as? [AnyObject] else{
            
            print("parseDictionary failed")
            return []
        }
        
        var books = [Book]()
        for bookDict in array {
            
            if let bookDict = bookDict as? [String : AnyObject]{
                
                let book = Book()
                
                if let volumeDict = bookDict["volumeInfo"] as? [String : AnyObject], title = volumeDict["title"] as? String{
                    
                    book.bookName =  title
                    
                    if let imageLinks = volumeDict["imageLinks"] as? [String : AnyObject], imageURL = imageLinks["smallThumbnail"] as? String{
                        
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BookTableViewIdentifiers.bookCell, forIndexPath: indexPath) as! BookCell
        
        cell.configureCell(books[indexPath.row])
        
        return cell
    }
    
    struct BookTableViewIdentifiers{
    
        static let bookCell = "BookCell"
    
    }

func showDataFetchFailError(){
    
    let alertController = UIAlertController(title: "Whoops...", message: "There was error in fetching data from server. Please try again.", preferredStyle: .Alert)
    
    let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
    
    alertController.addAction(action)
    presentViewController(alertController, animated: true, completion: nil)
    
}

    deinit{
    dataTask?.cancel()
    }

}
//
//  ViewController.swift
//  TestTwo
//
//  Created by Praneet Jain on 5/24/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

import UIKit

class BooksViewController: UITableViewController {

    var books = [Book]()
    var dataTask : NSURLSessionDataTask?
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Keeping a distance of 20points from top in tableview
    tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
    var cellNib = UINib(nibName: BooksViewIdentifiers.bookCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: BooksViewIdentifiers.bookCell)
        tableView.rowHeight = 80
        
        cellNib = UINib(nibName: BooksViewIdentifiers.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: BooksViewIdentifiers.loadingCell)
        
        fetchBooksFromURL()
    }

    func fetchBooksFromURL(){
    
    isLoading = true
        
    let stringURL = "https://www.googleapis.com/books/v1/volumes?q=Harry%20Potter%20Azkaban"
    let url = NSURL(string: stringURL)
    
    let session = NSURLSession.sharedSession()
    dataTask = session.dataTaskWithURL(url!, completionHandler: { data, response, error in
        
        if let data = data, dictionary = self.parseJSON(data){
        self.books = self.parseDictionary(dictionary)
        
            dispatch_async(dispatch_get_main_queue()){
            
            self.isLoading = false
            self.tableView.reloadData()
            }
            return
        }
        else{
        print("Failure: \(response)")
        }
        dispatch_async(dispatch_get_main_queue()){
        
            self.isLoading = false
            self.tableView.reloadData()
            self.showDataFetchFailError()
        }
    })
    
        dataTask?.resume()
        
    
    }
    
    
    func parseJSON(data : NSData) -> [String : AnyObject]?{
    
        do{
        
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String : AnyObject]
        
        }catch{
        
            print("Failed to parse JSON with error: \(error)")
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
                    
                        book.bookImageURL = imageURL
                    
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

    struct BooksViewIdentifiers {
        static let loadingCell = "LoadingCell"
        static let bookCell = "BookCell"
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isLoading{
        return 1
        }
        
        return books.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if isLoading{
        
            let cell = tableView.dequeueReusableCellWithIdentifier(BooksViewIdentifiers.loadingCell, forIndexPath: indexPath)
            let spinner = tableView.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
           
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(BooksViewIdentifiers.bookCell, forIndexPath: indexPath) as! BookCell
        
        if !books.isEmpty{
        let book = books[indexPath.row]
        cell.configureForBook(book)
        }
        
        return cell
    }
    
    func showDataFetchFailError(){
    
        let alertController = UIAlertController(title: "Whoops...", message: "There was error in fetching data from server. Please try again.", preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(action)
        presentViewController(alertController, animated: true, completion: nil)
    
    }
    
    
}


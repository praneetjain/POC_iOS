//
//  MasterViewController.m
//  MobileChallenge
//
//  Created by Praneet Jain on 9/13/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "AlbumCell.h"

//Constants
NSString *const Key_ALBUM_CELL = @"Cell";
NSString *const Key_LOADING_CELL = @"LoadingCell";
NSString *const Key_iTUNES_URL = @"http://itunes.apple.com/us/rss/topsongs/limit=100/xml";

@interface MasterViewController ()
{
    NSXMLParser* parser;
    NSMutableArray* feeds;
    NSMutableDictionary* entry;
    NSMutableString* title;
    NSMutableString* detailedLink;
    NSMutableString* link_height55;
    NSMutableString* link_height60;
    NSMutableString* link_height170;
    NSMutableString* price;
    NSString* element;
    NSString* currentHeight;
    BOOL isLoading;
    
    UIImageOrientation scrollOrientation;
    CGPoint lastPos;

}
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoading = NO;
    feeds = [[NSMutableArray alloc] init];
   
    //Start fetching and parsing data
    [self startParsing:[NSURL URLWithString:Key_iTUNES_URL]];
    
    //Adding refresh button on navigation bar and its event method.
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshList:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshList:(id)sender {
    
    if(feeds == nil || feeds.count == 0){
        [self startParsing:[NSURL URLWithString:Key_iTUNES_URL]];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Segues

//Makes HTTP connection to server and retrieves data.
-(void)startParsing:(NSURL*)url{
    
    if(url==nil){
        return;
    }
    //Fetching data from url in xml format
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask = [session dataTaskWithURL:url completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        if(error==nil){
            isLoading = YES;
            parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            [parser parse];
        }
        else{
            [self showErrorAlert];
        }
        
    }];
    [dataTask resume];


}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        
        //Sending data for current row selected to DetailViewController
        [controller setDetailItem:[feeds objectAtIndex:indexPath.row]];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isLoading){
        //Until value is not parsed
        return 1;
    }
    return feeds.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [UIView animateWithDuration:0.25 animations:^{
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    } completion:^(BOOL finished) {
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
    }];
    
    
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(isLoading){
        UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:Key_LOADING_CELL forIndexPath:indexPath];
        
        UIActivityIndicatorView* spinner = [cell viewWithTag:101];
        [spinner startAnimating];

        return cell;
    }
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:Key_ALBUM_CELL forIndexPath:indexPath];

    //Set values on UI components, inside cell
    [cell configureCell:[feeds objectAtIndex:indexPath.row]];

    return cell;
}

//Adding animation to cell
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isDragging) {
        UIView *myView = cell.contentView;
        CALayer *layer = myView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        if (scrollOrientation == UIImageOrientationDown) {
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI*0.5, 1.0f, 0.0f, 0.0f);
        } else {
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI*0.5, 1.0f, 0.0f, 0.0f);
        }
        layer.transform = rotationAndPerspectiveTransform;
        [UIView animateWithDuration:.5 animations:^{
            layer.transform = CATransform3DIdentity;
        }];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollOrientation = scrollView.contentOffset.y > lastPos.y?UIImageOrientationDown:UIImageOrientationUp;
    lastPos = scrollView.contentOffset;
}

#pragma mark - Parser methods

/*
 Parsing all the values from the response. Setting them as key-values pairs
 and storing all of them in an array.
 */
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

    element = elementName;
    
    if([element isEqualToString:@"entry"]){
    //create objects for required fields if "entry" element
    //is found in rss feed.
        
        entry = [[NSMutableDictionary alloc] init];
        title = [[NSMutableString alloc] init];
        detailedLink = [[NSMutableString alloc] init];
        link_height55 = [[NSMutableString alloc] init];
        link_height60 = [[NSMutableString alloc] init];
        link_height170 = [[NSMutableString alloc] init];
        price = [[NSMutableString alloc] init];
        
    }
    
    if ([elementName isEqualToString:@"im:price"]){
        NSString* amount = [attributeDict objectForKey:@"amount"];
        [entry setObject:amount forKey:@"price"];
    }
   
    if ([elementName isEqualToString:@"im:image"]){
        NSString* height = [attributeDict objectForKey:@"height"];
        currentHeight=height;
        if([height isEqualToString:@"55"])
        {
            [entry setObject:link_height55 forKey:@"image55"];
        }
        else if([height isEqualToString:@"60"])
        {
            [entry setObject:link_height60 forKey:@"image60"];
        }
        else if([height isEqualToString:@"170"])
        {
            [entry setObject:link_height170 forKey:@"image170"];
        }

    }
    
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{

    if([elementName isEqualToString:@"entry"]){
    
        [entry setObject:title forKey:@"title"];
        [entry setObject:detailedLink forKey:@"id"];
    
        //All all parsed elements from RSS feed in an array.
        [feeds addObject:[entry copy]];
    
    }
  
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

    if([element isEqualToString:@"title"]){
        [title appendString:string];
    }
    else if([element isEqualToString:@"id"]){
        [detailedLink appendString:string];
    }
    else if([element isEqualToString:@"im:image"]){
        //Storing all of the urls for different height values
        
        if([currentHeight isEqualToString:@"55"]){
        [link_height55 appendString:string];
        }
    
    else if([currentHeight isEqualToString:@"60"]){
        [link_height60 appendString:string];
    }
    else if([currentHeight isEqualToString:@"170"]){
        [link_height170 appendString:string];
    }
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    
    //Reload data for table view on UI thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        isLoading = NO;
        [self.tableView reloadData];
    });
}

//Error message if download fails
-(void)showErrorAlert{

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Request to server failed. Please try again." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

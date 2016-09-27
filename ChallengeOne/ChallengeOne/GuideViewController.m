//
//  ViewController.m
//  ChallengeOne
//
//  Created by Praneet Jain on 6/8/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import "GuideViewController.h"
#import "GuideCell.h"
#import "Guide.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface GuideViewController ()

@property (nonatomic, strong) NSMutableArray* guides;
@property (nonatomic, strong) NSMutableArray* arrayOfDict;
@property (nonatomic, strong) NSArray* orderedArray;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Giving the space of 20points from top.
    [self.tableView setContentInset:UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)];
            
    //Initializing and registering custom nibs for cells.
    UINib* cellNib = [UINib nibWithNibName:@"GuideCell" bundle: nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"GuideCell"];
    [self.tableView setRowHeight:100.0];
    
    self.guides = [[NSMutableArray alloc] init];
    
    [self fetchDataForGuides];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if(self.arrayOfDict != nil && self.arrayOfDict.count>0){
    
        return self.arrayOfDict.count;
    }

    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (self.arrayOfDict != nil && self.arrayOfDict.count>0) {
        
        //getting the dictionary from array using section as index.
        NSDictionary* sectionDict = self.arrayOfDict[section];
        
        //getting the name of key from dictionary.
        NSString* sectionTitle = [[sectionDict allKeys] objectAtIndex:0];
        return sectionTitle;
    }
    
    return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.arrayOfDict != nil && self.arrayOfDict.count>0) {
        
        NSDictionary* sectionDict = self.arrayOfDict[section];
        NSString* sectionTitle = [[sectionDict allKeys] objectAtIndex:0];
        
        return [[sectionDict objectForKey:sectionTitle] count];
    }
    
    return self.guides.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:22]];
    label.textAlignment = NSTextAlignmentLeft;
    NSString *string =[[[self.arrayOfDict objectAtIndex:section] allKeys] objectAtIndex:0];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    
    
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

            static NSString* cellIdentifier = @"GuideCell";
            
            GuideCell* cell = (GuideCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            
            NSDictionary* dictForSection = self.arrayOfDict[indexPath.section];
            NSString* keyForElementsInSection = [[dictForSection allKeys] objectAtIndex:0];
            Guide* tempGuide = [[dictForSection objectForKey:keyForElementsInSection] objectAtIndex:indexPath.row];
            
            [cell configureCellWithData:tempGuide];
            
            return cell;
}

-(void)fetchDataForGuides{

    NSString* stringURL =  @"https://www.guidebook.com/service/v2/upcomingGuides/";
    NSURL* URL = [NSURL URLWithString:stringURL];

    [SVProgressHUD show];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray* arrayGuides = responseObject[@"data"];
        
                for (NSDictionary* dictGuide in arrayGuides) {
        
                    NSString* tempName;
                    NSString* tempStartDate;
                    NSString* tempEndDate;
                    NSString* tempCity;
                    NSString* tempState;
        
                    if(dictGuide[@"name"]){
                        tempName = dictGuide[@"name"];
                    }
        
                    if(dictGuide[@"startDate"]){
                    tempStartDate = dictGuide[@"startDate"];
                    }
        
                    if(dictGuide[@"endDate"]){
                    tempEndDate = dictGuide[@"endDate"];
                    }
        
                    if(dictGuide[@"venue"][@"city"]){
                    tempCity = dictGuide[@"venue"][@"city"];
                    }
        
                    if(dictGuide[@"venue"][@"state"]){
                    tempState = dictGuide[@"venue"][@"state"];
                    }
        
                    Guide* guide = [[Guide alloc] initGuideWithName:tempName city:tempCity state:tempState startDate:tempStartDate andEndDate:tempEndDate];
                    
                    [self.guides addObject:guide];
                }
                
                [self getDictionaryForSections];
                    [SVProgressHUD dismiss];
                    [self.tableView reloadData];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    
    
}

//Creating the dictionaries with startDate as key and aray of guide objects as value.
-(void)getDictionaryForSections{
    
    //array to store all dictionaries with date as key and guide object as value.
    self.arrayOfDict = [[NSMutableArray alloc] init];
    
    self.orderedArray = [self sortedArrayAccordingToDate:self.guides];
    
    NSMutableArray* tempValueArray;
    
    NSString* lastStringDate = @"";

    NSMutableDictionary* dict;
    
    for (Guide* guide in self.orderedArray) {
        
        NSLog(@"%@", lastStringDate);
        NSLog(@"%@", guide.startDate);
        
        //Checking if last startDate and currentStartDate is same. If they are not same then a new key(value of startDate) has to be created. Number of elements in dictionary object defines number of sections.
        if (tempValueArray == nil || ![lastStringDate isEqualToString:guide.startDate]){
            
            dict = [[NSMutableDictionary alloc] init];
            tempValueArray = [[NSMutableArray alloc] init];
            if (dict != nil) {
                [self.arrayOfDict addObject:dict];
            }
        }
        
        lastStringDate = guide.startDate;
        
        [tempValueArray addObject:guide];
        [dict setObject:tempValueArray forKey:guide.startDate];
        
    }
        //redrawing the layout afer adding sections.
        [self.tableView layoutSubviews];
    
}

//SortingaArray
-(NSArray*)sortedArrayAccordingToDate:(NSMutableArray*)guides{

    //remove space
    for(int i=0; i< [self.guides count]; i++){
        
        
        Guide* tempGuide = self.guides[i];
        NSString* startDate = tempGuide.startDate;
        startDate = [startDate stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSArray* array = [startDate componentsSeparatedByString:@" "];
        int year = [[array objectAtIndex:2] intValue];
        int month = [self getMonthNumber:([array objectAtIndex:0])];
        int date = [[array objectAtIndex:1] intValue];
        
        
        for (int j = i; j < [self.guides count]; j++) {
            
            Guide* tempGuideTwo = self.guides[j];
            NSString* startDateTwo = tempGuideTwo.startDate;
            startDateTwo = [startDateTwo stringByReplacingOccurrencesOfString:@"," withString:@""];
            NSArray* arrayTwo = [startDateTwo componentsSeparatedByString:@" "];
            int yearTwo = [[arrayTwo objectAtIndex:2] intValue];
            int monthTwo = [self getMonthNumber:([arrayTwo objectAtIndex:0])];
            int dateTwo = [[arrayTwo objectAtIndex:1] intValue];

         
            if (year > yearTwo) {
                
                Guide* tempObject = self.guides[j];
                self.guides[j] = guides[i];
                guides[i] = tempObject;
                
            }
            else if(year == yearTwo && month > monthTwo){
            
                Guide* tempObject = self.guides[j];
                self.guides[j] = guides[i];
                guides[i] = tempObject;

            }
            else if(year == yearTwo && month == monthTwo && date > dateTwo){
            
                Guide* tempObject = self.guides[j];
                self.guides[j] = guides[i];
                guides[i] = tempObject;
            }
            
        }
        
        
        
    }
    return guides;


    
}

//Method to return the month number for month name.
-(int)getMonthNumber:(NSString*)monthName{

    if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"jan"]){
    
        return 1;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"feb"]){
    
        return 2;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"mar"]){
        
        return 3;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"apr"]){
        
        return 4;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"may"]){
        
        return 5;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"jun"]){
        
        return 6;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"jul"]){
        
        return 7;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"aug"]){
        
        return 8;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"sep"]){
        
        return 9;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"oct"]){
        
        return 10;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"nov"]){
        
        return 11;
    }
    else if([[[monthName substringToIndex:3] lowercaseString] isEqualToString:@"dec"]){
        
        return 12;
    }
    
    
    return -1;
}

@end

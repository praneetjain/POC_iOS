//
//  GuideCellTableViewCell.h
//  ChallengeOne
//
//  Created by Praneet Jain on 6/8/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Guide.h"

@interface GuideCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelDetailsText;

-(void)configureCellWithData:(Guide*)guide;

@end

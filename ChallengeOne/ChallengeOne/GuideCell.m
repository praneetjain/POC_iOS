//
//  GuideCellTableViewCell.m
//  ChallengeOne
//
//  Created by Praneet Jain on 6/8/16.
//  Copyright © 2016 Praneet Jain. All rights reserved.
//

#import "GuideCell.h"

@implementation GuideCell
@synthesize labelName, labelDetailsText;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithData:(Guide *)guide{

    if(guide != nil){
    
        [labelName setText:guide.name];
        
        NSString* detailsText;
        
        if(guide.state == nil && guide.city == nil){
            detailsText = [NSString stringWithFormat:@"Ends - %@",guide.endDate];
        }
        else if(guide.state == nil && guide.city != nil){
           detailsText = [NSString stringWithFormat:@"Ends - %@ : %@",guide.endDate,guide.city];
        }
        else if(guide.state != nil && guide.city == nil){
        detailsText = [NSString stringWithFormat:@"Ends - %@ : %@, %@",guide.endDate,guide.city,guide.state];
        }
        else{
        detailsText = [NSString stringWithFormat:@"Ends - %@ : %@, %@",guide.endDate,guide.city,guide.state];
        }
    
        [labelDetailsText setText:detailsText];
    
    
    }



}

@end

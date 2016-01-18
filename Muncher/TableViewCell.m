//
//  TableViewCell.m
//  Muncher
//
//  Created by Connie Shi on 12/8/15.
//  Copyright © 2015 Connie Shi. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

@synthesize image, nameLabel, addressLabel, cuisineLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

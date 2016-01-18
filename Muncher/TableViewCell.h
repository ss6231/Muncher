//
//  TableViewCell.h
//  Muncher
//
//  Created by Connie Shi on 12/8/15.
//  Copyright © 2015 Connie Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *cuisineLabel;

@end

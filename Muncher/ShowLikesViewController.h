//
//  ShowLikesViewController.h
//  Muncher
//  Connie Shi and Sana Sheikh
//
//  Created by Connie Shi on 12/8/15.
//  Copyright © 2015 Connie Shi. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ShowLikesViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

//
//  ShowLikesViewController.m
//  Muncher
//  Connie Shi and Sana Sheikh
//
//  Created by Connie Shi on 12/8/15.
//  Copyright © 2015 Connie Shi. All rights reserved.

#import "ShowLikesViewController.h"

@implementation ShowLikesViewController {
    NSMutableArray *likes;
    PFUser *currentUser;
}

@synthesize tableView;

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    [self getLikes: ^(void) {
        [tableView reloadData];
    }];
    NSLog(@"appeared!");
}

// Get only the restaurants that the user liked
-(void) getLikes: (void (^) (void))completion {
    likes = [[NSMutableArray alloc] init];
    currentUser = [PFUser currentUser];
    PFRelation *likesRelation = [currentUser relationForKey:@"likes"];
    [[likesRelation query] findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            likes = [[NSMutableArray alloc] initWithArray: objects];
            completion();
        } else {
            NSLog(@"noooo :(");
        }
    }];
}

// Table view to store the restaurants that the user likes
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    NSLog(@"%lu", (unsigned long)[likes count]);

    return [likes count];
}

// Set each cell for table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    // Get the liked PFObject stored in database (the restaurant that the user liked)
    PFObject *obj = [likes objectAtIndex: indexPath.row];

    // Populate each cell with the restaurant information including...
    
    // Load image to a default first in order for the image to show
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
    imageView.image = [UIImage imageNamed:@"loading.png"];
    
    // Load name of restaurant
    UILabel *name = (UILabel*)[cell viewWithTag:101];
    name.text = [obj objectForKey:@"name"];
    
    // Load the address of the restaurant
    UILabel *address = (UILabel*)[cell viewWithTag:102];
    address.text = [obj objectForKey:@"address"];
    
    // Load the cuisine
    UILabel *cuisine = (UILabel*)[cell viewWithTag:103];
    cuisine.text = [obj objectForKey:@"cuisine"];
    
    // Load the phone number
    UILabel *phone = (UILabel*)[cell viewWithTag:104];
    phone.text = [obj objectForKey:@"phone"];
    
    // Load the photo of the actual restaurant obtained from PFObject
    PFFile *photoFile = [obj objectForKey:@"image"];
    [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *photo = [UIImage imageWithData:data];
            imageView.image = photo;
        }
    }];
    
    return cell;
}

// Set so we can edit row at index path
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Allows editing style
-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *object = [likes objectAtIndex:indexPath.row];
        [likes removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded){
                NSLog(@"error");
            }
        }];
    }
}

@end

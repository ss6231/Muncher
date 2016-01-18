//
//  AddRestaurantViewController.h
//  Muncher
//  Connie Shi and Sana Sheikh
//
//  Created by Connie Shi on 12/8/15.
//  Copyright © 2015 Connie Shi. All rights reserved.

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddRestaurantViewController : UIViewController
    <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *restaurantName;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *cuisine;

@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UIButton    *signUp;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

- (IBAction)selectPhoto:(id)sender;
- (IBAction)submit:(id)sender;


@end

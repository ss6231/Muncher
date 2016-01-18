//
//  AddRestaurantViewController.m
//  Muncher
//  Connie Shi and Sana Sheikh
//
//  Created by Connie Shi on 12/8/15.
//  Copyright © 2015 Connie Shi. All rights reserved.

#import "AddRestaurantViewController.h"

@implementation AddRestaurantViewController
@synthesize restaurantName, address, cuisine, price, phone, photo, signUp;

- (void)viewDidLoad {
    [super viewDidLoad];
}

// Set the background
-(void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [[UIColor alloc]
        initWithRed:.92 green:.93 blue:.95 alpha:1];
}

// Allows the user to select a photo from the Photo Gallery
- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

// Picker Controller allows you to pick an image from Photo Gallery
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo: (NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.photo.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// Cancel option from picking a photo in photo gallery
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// Submit the form to add a restaurant
- (IBAction)submit:(id)sender {
    // Check if all fields have been filled out to prevent errors
    if (!restaurantName.hasText || !address.hasText || !cuisine.hasText
            || !price.hasText || !phone.hasText || photo.image == nil) {
        
        UIAlertController * alert =     [UIAlertController
                                         alertControllerWithTitle:@"Missing Restaurant Info!"
                                         message:@"Please input all fields for the new restaurant before submitting."
                                         preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton =      [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                         }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (restaurantName.hasText == 1) {
        NSLog (@"has text");
    } else {
        NSLog (@"no text");
    }
    
    // Create a new restaurant object to add to database
    PFObject *restaurant = [PFObject objectWithClassName:@"Restaurant"];
    restaurant[@"name"] = restaurantName.text;
    restaurant[@"address"] = address.text;
    restaurant[@"cuisine"] = cuisine.text;
    restaurant[@"price"] = price.text;
    restaurant[@"phone"] = phone.text;
    
    // Convert uploaded image to JPEG with 50% quality
    NSData* data = UIImageJPEGRepresentation(photo.image, 0.5f);
    PFFile *imageFile = [PFFile fileWithName: restaurantName.text data:data];
    
    // Save the image to Parse
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // The image has now been uploaded to Parse. Associate it with a new object
            [restaurant setObject:imageFile forKey:@"image"];
            
            // Save the restaurant to database asynchronously
            [restaurant saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved");
                    UIAlertController * alert =     [UIAlertController
                                                    alertControllerWithTitle:@"Submitted!"
                                                     message:@"Added new restaurant. Swipe or add another!"
                                                     preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton =      [UIAlertAction
                                                     actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                                     }];
                    
                    [alert addAction:yesButton];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                
                // Clear out the fields for the next form submission
                restaurantName.text = @"";
                address.text = @"";
                cuisine.text = @"";
                price.text = @"";
                phone.text = @"";
                photo.image = nil;
            }];
        }
    }];
    [restaurant saveInBackground];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end

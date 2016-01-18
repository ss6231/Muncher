//
//  ViewController.m
//  Muncher
//  Connie Shi and Sana Sheikh
//
//  Created by Connie Shi on 12/7/15.
//  Copyright © 2015 Connie Shi. All rights reserved.

#import "ViewController.h"
#import "DraggableViewBackground.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    DraggableViewBackground *draggableBackground =
        [[DraggableViewBackground alloc] initWithFrame:self.view.frame];
    [self.view addSubview: draggableBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

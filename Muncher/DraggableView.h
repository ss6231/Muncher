//
//  DraggableView.h
//  Connie Shi and Sana Sheikh
//  Tinder Swipe Cards API: https://github.com/cwRichardKim/TinderSimpleSwipeCards
//
//  Created by Connie Shi on 12/7/15.
//  Copyright © 2015 Connie Shi. All rights reserved.

#import <UIKit/UIKit.h>
#import "OverlayView.h"
#import <Parse/Parse.h>

@protocol DraggableViewDelegate <NSObject>

-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@end

@interface DraggableView : UIView

@property (weak) id <DraggableViewDelegate> delegate;

@property (nonatomic, strong)UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic)CGPoint originalPoint;
@property (nonatomic,strong)OverlayView* overlayView;
@property (nonatomic,strong)UIImageView* photo;
@property (nonatomic,strong)UILabel* name;
@property (nonatomic,strong)UILabel* address;
@property (nonatomic,strong)UILabel* cuisine;
@property (nonatomic,weak)PFObject* restaurant;

-(void)leftClickAction;
-(void)rightClickAction;

@end

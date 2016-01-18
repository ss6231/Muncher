//
//  DraggableViewBackground.h
//  Connie Shi and Sana Sheikh
//  Tinder Swipe Cards API: https://github.com/cwRichardKim/TinderSimpleSwipeCards
//
//  Created by Connie Shi on 12/7/15.
//  Copyright © 2015 Connie Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"
#import <Parse/Parse.h>

@interface DraggableViewBackground : UIView <DraggableViewDelegate>

// Methods called in DraggableView
-(void)cardSwipedLeft:(UIView *)card;
-(void)cardSwipedRight:(UIView *)card;

@property (retain,nonatomic)NSMutableArray* restaurants;
@property (retain,nonatomic)NSMutableArray* allCards;

@end

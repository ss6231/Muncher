//
//  DraggableView.m
//  Connie Shi and Sana Sheikh
//  Tinder Swipe Cards API: https://github.com/cwRichardKim/TinderSimpleSwipeCards
//
//  Created by Connie Shi on 12/7/15.
//  Copyright © 2015 Connie Shi. All rights reserved.

// Distance from center where the action applies. Higher = swipe further in order for the action to be called
#define ACTION_MARGIN 120

// How quickly the card shrinks. Higher = slower shrinking
#define SCALE_STRENGTH 4

// Upper bar for how much the card shrinks. Higher = shrinks less
#define SCALE_MAX .93

// Maximum rotation allowed in radians.  Higher = card can keep rotating longer
#define ROTATION_MAX 1

// Strength of rotation. Higher = weaker rotation
#define ROTATION_STRENGTH 320

// Higher = stronger rotation angle
#define ROTATION_ANGLE M_PI/8

#import "DraggableView.h"

@implementation DraggableView {
    CGFloat xFromCenter;
    CGFloat yFromCenter;
}

// Delegate is instance of ViewController
@synthesize delegate;
@synthesize panGestureRecognizer;
@synthesize photo, name, address, cuisine;
@synthesize overlayView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        // Set up fields in Draggable View with name, address, cuisine, and image
        photo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 200)];
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, self.frame.size.width-40, 50)];
        [[self name] setFont:[UIFont fontWithName:@"HelveticaNeue" size:25]];
        name.numberOfLines = 0;
        name.lineBreakMode = NSLineBreakByWordWrapping;
        
        address = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, self.frame.size.width-40, 100)];
        [[self address] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
        address.numberOfLines = 0;
        address.lineBreakMode = NSLineBreakByWordWrapping;
        
        cuisine = [[UILabel alloc] initWithFrame:CGRectMake(20, 320, self.frame.size.width-40, 50)];
        [[self cuisine] setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
        
        self.backgroundColor = [UIColor whiteColor];
        panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(beingDragged:)];
        
        // Set up subviews
        [self addGestureRecognizer:panGestureRecognizer];
        [self addSubview:photo];
        [self addSubview:name];
        [self addSubview:address];
        [self addSubview:cuisine];
        
        overlayView = [[OverlayView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-100, 0, 100, 100)];
        overlayView.alpha = 0;
        [self addSubview:overlayView];
    }
    return self;
}

-(void)setupView {
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.2;
    self.layer.shadowOffset = CGSizeMake(1, 1);
}

// Called when you move your finger across the screen, called many times a second
-(void)beingDragged:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // This extracts the coordinate data from your swipe movement
    xFromCenter = [gestureRecognizer translationInView:self].x;
    yFromCenter = [gestureRecognizer translationInView:self].y;
    
    // Checks what state the gesture is in
    switch (gestureRecognizer.state) {
            
        // Just started swiping
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
            
        // In the middle of a swipe
        case UIGestureRecognizerStateChanged:{
            
            // Dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            CGFloat rotationStrength = MIN(xFromCenter / ROTATION_STRENGTH, ROTATION_MAX);
            
            // Degree change in radians
            CGFloat rotationAngel = (CGFloat) (ROTATION_ANGLE * rotationStrength);
            
            // Amount the height changes when you move the card up to a certain point
            CGFloat scale = MAX(1 - fabsf(rotationStrength) / SCALE_STRENGTH, SCALE_MAX);
            
            // Move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter);
            
            // Rotate by certain amount
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            
            // Scale by certain amount
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            
            // Apply transformations
            self.transform = scaleTransform;
            [self updateOverlay:xFromCenter];
            
            break;
        };
            
        // Let go of the card
        case UIGestureRecognizerStateEnded: {
            [self afterSwipeAction];
            break;
        };
            
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

// Checks to see if you are moving right or left and applies the correct overlay image
-(void)updateOverlay:(CGFloat)distance {
    if (distance > 0) {
        overlayView.mode = GGOverlayViewModeRight;
    } else {
        overlayView.mode = GGOverlayViewModeLeft;
    }
    overlayView.alpha = MIN(fabsf(distance)/100, 0.4);
}

// Called when the card is let go
- (void)afterSwipeAction {
    if (xFromCenter > ACTION_MARGIN) {
        [self rightAction];
    } else if (xFromCenter < -ACTION_MARGIN) {
        [self leftAction];
    } else { //%%% resets the card
        [UIView animateWithDuration:0.3
            animations:^{
                self.center = self.originalPoint;
                self.transform = CGAffineTransformMakeRotation(0);
                overlayView.alpha = 0;
        }];
    }
}

// Called when a swipe exceeds the ACTION_MARGIN to the right
-(void)rightAction {
    CGPoint finishPoint = CGPointMake(500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    NSLog(@"YES");
}

// Called when a swipe exceeds the ACTION_MARGIN to the left
-(void)leftAction {
    CGPoint finishPoint = CGPointMake(-500, 2*yFromCenter +self.originalPoint.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    NSLog(@"NO");
}

-(void)rightClickAction {
    CGPoint finishPoint = CGPointMake(600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedRight:self];
    NSLog(@"YES");
}

-(void)leftClickAction {
    CGPoint finishPoint = CGPointMake(-600, self.center.y);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.center = finishPoint;
                         self.transform = CGAffineTransformMakeRotation(-1);
                     }completion:^(BOOL complete){
                         [self removeFromSuperview];
                     }];
    
    [delegate cardSwipedLeft:self];
    NSLog(@"NO");
}

@end

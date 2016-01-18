//
//  DraggableViewBackground.m
//  Connie Shi and Sana Sheikh
//  Tinder Swipe Cards API: https://github.com/cwRichardKim/TinderSimpleSwipeCards
//
//  Created by Connie Shi on 12/7/15.
//  Copyright © 2015 Connie Shi. All rights reserved.

#import "DraggableViewBackground.h"

@implementation DraggableViewBackground{
    NSInteger cardsLoadedIndex;  // Index of the card loaded into the loadedCards array last
    NSMutableArray *loadedCards; // Array of card loaded
    NSMutableArray *seen;
    NSMutableArray *allRestaurants;
    
    UIButton* checkButton;
    UIButton* xButton;
}

// Max number of cards loaded at any given time, must be greater than 1
static const int MAX_BUFFER_SIZE = 2;

// Height of the draggable card
static const float CARD_HEIGHT = 386;

// Width of the draggable card
static const float CARD_WIDTH = 290;

// All unseen restaurants to be served as swipable cards to the user
@synthesize restaurants;

// All the cards
@synthesize allCards;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [super layoutSubviews];
        [self setupView];
    
        // Callback function to get all restaurants and load cards
        [self getRestaurants: ^(void) {
            loadedCards = [[NSMutableArray alloc] init];
            allCards = [[NSMutableArray alloc] init];
            cardsLoadedIndex = 0;
            [self loadCards];
        }];
    }
    
    // Set the logo to Muncher image
    UIImageView* logoView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 370, 240)];
    UIImage *photo = [UIImage imageNamed:@"logo.png"];
    logoView.image = photo;
    
    // Set the label in the back to notify users that there are no more unseen restaurants
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(80, 300, 600, 100)];
    label.text = @"No more restaurants!";
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
    [label setTextColor: [UIColor blackColor]];
    
    [self addSubview: logoView];
    [self addSubview: label];
    return self;
}

// Callback asynchronous function that retrieves all unseen restaurants from the database
// By querying all restaurants and doesNotMatchKey in the seen relation
- (void) getRestaurants: (void (^) (void))completion {
    PFUser *user = [PFUser currentUser];

    // Get all restaurants and query it against seen relation
    PFQuery *queryAll = [PFQuery queryWithClassName: @"Restaurant"];
    PFRelation *relation = [user relationForKey:@"seen"];
    PFQuery *querySeen = [relation query];
    [queryAll whereKey:@"objectId" doesNotMatchKey:@"objectId" inQuery:querySeen];
    
    // Retrieve all restaurants that have not been seen before
    [queryAll findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            restaurants = [[NSMutableArray alloc] initWithArray: objects];
            completion();
        } else {
            NSLog(@"noooo :(");
        }
    }];
}

// Sets up the extra buttons on the screen
-(void)setupView {
    
    // Show buttons check or x buttons whens swiping
    self.backgroundColor = [UIColor colorWithRed:.92 green:.93 blue:.95 alpha:1];
    xButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 600, 59, 59)];
    [xButton setImage:[UIImage imageNamed:@"xButton"] forState:UIControlStateNormal];
    [xButton addTarget:self action:@selector(swipeLeft) forControlEvents:UIControlEventTouchUpInside];
    checkButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 600, 59, 59)];
    [checkButton setImage:[UIImage imageNamed:@"checkButton"] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(swipeRight) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:xButton];
    [self addSubview:checkButton];
}

// Creates a card and returns it, uses "index" to indicate where the information should be pulled
-(DraggableView *)createDraggableViewWithDataAtIndex:(NSInteger)index {
    DraggableView *draggableView = [[DraggableView alloc]initWithFrame:
        CGRectMake((self.frame.size.width - CARD_WIDTH)/2,
                   (self.frame.size.height - CARD_HEIGHT)/2, CARD_WIDTH, CARD_HEIGHT)];
    
    // Get the PFFile for the photo image and load it to draggable view's photo
    PFObject *obj = [restaurants objectAtIndex:index];
    PFFile *photoFile = [obj objectForKey:@"image"];
    
    // Load the image
    [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *photo = [UIImage imageWithData:data];
            draggableView.photo.image = photo;
        }
    }];
    
    // Create and set the name, address, cuisine, etc. within draggable view
    draggableView.name.text = [obj objectForKey:@"name"];
    draggableView.address.text = [obj objectForKey:@"address"];
    draggableView.cuisine.text = [obj objectForKey:@"cuisine"];
    draggableView.restaurant = obj;
    draggableView.delegate = self;
    return draggableView;
}

// Loads all the cards and puts the first x in the "loaded cards" array
-(void)loadCards {
    if ([restaurants count] > 0) {
        NSInteger numLoadedCardsCap =(([restaurants count] > MAX_BUFFER_SIZE)
                                      ? MAX_BUFFER_SIZE:[restaurants count]);

        for (int i = 0; i<[restaurants count]; i++) {
            DraggableView* newCard = [self createDraggableViewWithDataAtIndex:i];
            [allCards addObject:newCard];
            
            if (i<numLoadedCardsCap) {
                [loadedCards addObject:newCard];
            }
        }
        
        // Displays the small number of loaded cards dictated by MAX_BUFFER_SIZE so that not all the cards
        // are showing at once and clogging a ton of data
        for (int i = 0; i<[loadedCards count]; i++) {
            if (i>0) {
                [self insertSubview:[loadedCards objectAtIndex:i]
                       belowSubview:[loadedCards objectAtIndex:i-1]];
            } else {
                [self addSubview:[loadedCards objectAtIndex:i]];
            }
            cardsLoadedIndex++; // We loaded a card into loaded cards, so we have to increment
        }
    }
}

// Action called when the card goes to the left.
-(void)cardSwipedLeft:(UIView *)card; {
    [loadedCards removeObjectAtIndex:0]; // Card was swiped, so it's no longer a "loaded card"
    
    // If we haven't reached the end of all cards, put another into the loaded cards
    if (cardsLoadedIndex < [allCards count]) {
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++; // Loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)]
               belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    
    // If card is left swiped, add it to the seen relation
    DraggableView *view = (DraggableView*) card;
    [self addToSeenOrLikes: view withRelation:@"seen"];
}

// Action called when the card goes to the right.
-(void)cardSwipedRight:(UIView *)card {
    [loadedCards removeObjectAtIndex:0]; // Card was swiped, so it's no longer a "loaded card"
    
    // If we haven't reached the end of all cards, put another into the loaded cards
    if (cardsLoadedIndex < [allCards count]) {
        [loadedCards addObject:[allCards objectAtIndex:cardsLoadedIndex]];
        cardsLoadedIndex++; // Loaded a card, so have to increment count
        [self insertSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-1)]
               belowSubview:[loadedCards objectAtIndex:(MAX_BUFFER_SIZE-2)]];
    }
    
    // If card is right swiped, it is liked, so add it both to seen and likes relations
    DraggableView *view = (DraggableView*) card;
    [self addToSeenOrLikes: view withRelation:@"seen"];
    [self addToSeenOrLikes: view withRelation:@"likes"];
}

// Method adds the restaurant to either seen or likes relation
-(void)addToSeenOrLikes:(DraggableView*) card withRelation:(NSString*)column {
    PFUser *currentUser = [PFUser currentUser];
    PFRelation *seenRelation = [currentUser relationForKey: column];
    
    [seenRelation addObject: card.restaurant];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Saved");
        } else {
            NSLog(@"Not saved");
        }
    }];
}

// When you hit the right button, this is called and substitutes the swipe
-(void)swipeRight {
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeRight;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView rightClickAction];
}

// When you hit the left button, this is called and substitutes the swipe
-(void)swipeLeft {
    DraggableView *dragView = [loadedCards firstObject];
    dragView.overlayView.mode = GGOverlayViewModeLeft;
    [UIView animateWithDuration:0.2 animations:^{
        dragView.overlayView.alpha = 1;
    }];
    [dragView leftClickAction];
}

@end

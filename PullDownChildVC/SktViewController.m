//
//  SktViewController.m
//  PullDownVC
//
//  Created by amar tk on 24/03/14.
//  Copyright (c) 2014 startKoding. All rights reserved.
//

#import "SktViewController.h"
#define OVERLAY_HEIGHT  50.0
#define PAN_TIMING      0.5f

@interface SktViewController ()
{
    SktOverlayViewController *overlayVC;
    CGPoint finalPoint;
}
@end

@implementation SktViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //create an instance of the overlay view controller
    overlayVC = [[SktOverlayViewController alloc] initWithNibName:@"SktOverlayViewController" bundle:nil];
    
    //set the frame for the child view
    CGRect overlayFrame = CGRectMake(0, OVERLAY_HEIGHT - overlayVC.view.frame.size.height, overlayVC.view.frame.size.width, overlayVC.view.frame.size.height);
    overlayVC.view.frame = overlayFrame;
    
    //add the overlay as child view controller
    [self addChildViewController:overlayVC];
    [self.view addSubview:overlayVC.view];
    [overlayVC didMoveToParentViewController:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //Add a gesture to the label on the overlay vc
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOverLayView:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [panGesture setDelegate:self];
    [overlayVC.pullLabel addGestureRecognizer:panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toggleOverLayView:(id)sender
{
    CGPoint translatedPoint = [(UIPanGestureRecognizer *) sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:self.view];
    
    UIGestureRecognizerState state = [(UIPanGestureRecognizer *) sender state];
    if (state == UIGestureRecognizerStateBegan) {
        
        if (velocity.y > 0) {
            //moving down
        } else {
            //moving up
        }
        
    } else if (state == UIGestureRecognizerStateChanged) {
        
        //set the new frame for the overlay vc
        CGRect overlayFrame = overlayVC.view.frame ;
        overlayFrame.origin.y = overlayFrame.origin.y + translatedPoint.y;
        overlayVC.view.frame = overlayFrame;
        [sender setTranslation:CGPointZero inView:self.view];
        
        //set the end point so that it can be used to finish the animation in the direction intended by the user
        if (velocity.y > 0) {
            finalPoint = CGPointMake(0, 0);
        } else {
            finalPoint = CGPointMake(0, OVERLAY_HEIGHT - overlayVC.view.frame.size.height);
        }
        
    } else if (state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:PAN_TIMING delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            CGRect overlayFrame = overlayVC.view.frame;
            overlayFrame.origin = finalPoint;
            overlayVC.view.frame = overlayFrame;
            [sender setTranslation:CGPointZero inView:self.view];
            
        } completion:^(BOOL finished) {
            
            //changet the label text to the appropraite one
            if (CGPointEqualToPoint(finalPoint, CGPointZero)) {
                [overlayVC.pullLabel setText:@"Pull me Up"];
            } else {
                [overlayVC.pullLabel setText:@"Pull me Down"];
            }
        }];
    }
}

@end

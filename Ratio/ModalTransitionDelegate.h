//
//  ModalTransitionDelegate.h
//  Ratio
//
//  Created by Matthew Hillman on 10/3/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) NSString *storyboardViewId;
@property (nonatomic, strong) UIViewController *controllerToPresent; // either id or view controller
- (instancetype)initWithSender:(UIViewController *)sender storyboardViewControlerToPresent:(NSString *)name callback:(void (^)(void))callback;
- (instancetype)initWithSender:(UIViewController *)sender viewControlerToPresent:(UIViewController *)controller callback:(void (^)(void))callback;
-(void)presentMenu;
-(void)userDidPan:(UIScreenEdgePanGestureRecognizer *)recognizer;
@end

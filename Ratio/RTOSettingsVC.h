//
//  RTOSettingsVC.h
//  Ratio
//
//  Created by Matthew Hillman on 10/8/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RTOSettingsDelegate <NSObject>

- (void)defaultsChanged;

@end

@interface RTOSettingsVC : UIViewController
@property (nonatomic, weak) id<RTOSettingsDelegate> delegate;
@end

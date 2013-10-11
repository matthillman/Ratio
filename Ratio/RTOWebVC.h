//
//  RTOWebVC.h
//  Ratio
//
//  Created by Matthew Hillman on 10/10/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ModalWebViewDismiss
- (void)dismiss;
@end

@interface RTOWebVC : UIViewController
@property (nonatomic, strong) NSString *htmlString;
@property (weak, nonatomic) NSString *barTitle;
@property (nonatomic, weak) id<ModalWebViewDismiss>delegate;
@end

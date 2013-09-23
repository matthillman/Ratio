//
//  RTORatioPieView.h
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTORatio.h"

@interface RTORatioPieView : UIView
@property (nonatomic, strong) RTORatio *ratio;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

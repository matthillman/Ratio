//
//  RTOCacluationCell.h
//  Ratio
//
//  Created by Matthew Hillman on 9/24/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTORatioPieView.h"

@class RTOCacluationCell;

@protocol RTOCalculationDelegate <NSObject>
- (void)calculationRow:(RTOCacluationCell *)sender updatedUnitTo:(NSString *)unit;
@end

@interface RTOCacluationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UIButton *unitButton;
@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;
@property (weak, nonatomic) IBOutlet RTORatioPieView *ratioPieView;
@property (weak, nonatomic) id <RTOCalculationDelegate> delegate;
@end

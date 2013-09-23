//
//  RTOListCVC.h
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTORatioPieView.h"

@interface RTOListCVC : UICollectionViewCell
@property (weak, nonatomic) IBOutlet RTORatioPieView *ratioPieView;
@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;
@end

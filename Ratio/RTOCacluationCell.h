//
//  RTOCacluationCell.h
//  Ratio
//
//  Created by Matthew Hillman on 9/24/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTOCacluationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet UIButton *unitButton;
@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;
@end

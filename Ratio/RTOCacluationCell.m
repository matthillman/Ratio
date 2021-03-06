//
//  RTOCacluationCell.m
//  Ratio
//
//  Created by Matthew Hillman on 9/24/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTOCacluationCell.h"
#import "RTOUnitConverter.h"
#import "UIColor+RGB.h"

@interface RTOCacluationCell () <UIActionSheetDelegate>
@property (nonatomic, strong) UIActionSheet *unitsSheet;
@end

@implementation RTOCacluationCell

- (IBAction)changeUnit
{
    self.unitsSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Change Units for %@", self.ingredientLabel.text] delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *unit in [RTOUnitConverter unitListForIngredientNamed:self.ingredientLabel.text]) {
        [self.unitsSheet addButtonWithTitle:[unit capitalizedString]];
    }
    [self.unitsSheet addButtonWithTitle:@"Cancel"];
    self.unitsSheet.cancelButtonIndex = self.unitsSheet.numberOfButtons-1;
    self.unitsSheet.tintColor = [UIColor colorForR:255 G:22 B:23 A:1];
    [self.unitsSheet showInView:self.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self.unitButton setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
        [self.delegate calculationRow:self updatedUnitTo:[actionSheet buttonTitleAtIndex:buttonIndex]];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subView in actionSheet.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            [button setTitleColor:[UIColor colorForR:255 G:22 B:23 A:1] forState:UIControlStateNormal|UIControlStateSelected|UIControlStateHighlighted];
        }
    }
}

@end

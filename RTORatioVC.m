//
//  RTORatioVC.m
//  Ratio
//
//  Created by Matthew Hillman on 9/21/13.
//  Copyright (c) 2013 Matthew Hillman. All rights reserved.
//

#import "RTORatioVC.h"
#import "RTORatioCVC.h"
#import "RTOListCVC.h"
#import "RTOCacluationCell.h"
#import "RTOUnitConverter.h"

@interface RTORatioVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, RTOCalculationDelegate>
@property (nonatomic, strong) UIActionSheet *unitsSheet;
@end

@implementation RTORatioVC
- (IBAction)changeRatioView
{
    [self changeRatioViewWithIndex:self.viewSelectSegmentedControl.selectedSegmentIndex animated:YES];
}

#define ANIMATION_DURATION 0.25

- (void)changeRatioViewWithIndex:(NSInteger)index animated:(BOOL)animated
{
    CGFloat dx = -1 * index * self.view.bounds.size.width;
    CGFloat dy = 0;
    
    if (animated) {
        CABasicAnimation *ra = [CABasicAnimation animationWithKeyPath:@"transform"];
        ra.autoreverses = NO;
        ra.duration = ANIMATION_DURATION;
        ra.fromValue = [NSValue valueWithCATransform3D:self.ratioCollectionView.layer.transform];
        ra.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.ratioCollectionView.layer.bounds.origin.x + dx, dy, 0)];
        
        CABasicAnimation *ta = [CABasicAnimation animationWithKeyPath:@"transform"];
        ta.autoreverses = NO;
        ta.duration = ANIMATION_DURATION;
        ta.fromValue = [NSValue valueWithCATransform3D:self.calculateTableView.layer.transform];
        ta.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.calculateTableView.layer.bounds.origin.x + dx, dy, 0)];
        
        CABasicAnimation *txta = [CABasicAnimation animationWithKeyPath:@"transform"];
        txta.autoreverses = NO;
        txta.duration = ANIMATION_DURATION;
        txta.fromValue = [NSValue valueWithCATransform3D:self.instructionsTextView.layer.transform];
        txta.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.instructionsTextView.layer.bounds.origin.x + dx, dy, 0)];
        
        [self.ratioCollectionView.layer addAnimation:ra forKey:nil];
        [self.calculateTableView.layer addAnimation:ta forKey:nil];
        [self.instructionsTextView.layer addAnimation:txta forKey:nil];
    }
    
    self.ratioCollectionView.layer.transform = CATransform3DMakeTranslation(self.ratioCollectionView.layer.bounds.origin.x + dx, 0, 0);
    self.calculateTableView.layer.transform = CATransform3DMakeTranslation(self.calculateTableView.layer.bounds.origin.x + dx, 0, 0);
    self.instructionsTextView.layer.transform = CATransform3DMakeTranslation(self.instructionsTextView.layer.bounds.origin.x + dx, 0, 0);
}

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ratio.ingredients count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.ratio.name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.calculateTableView dequeueReusableCellWithIdentifier:indexPath.item == 0 ? @"calcHeading" : @"calcRow"];
    if ([cell isKindOfClass:[RTOCacluationCell class]]) {
        RTOCacluationCell *rcc = (RTOCacluationCell *)cell;
        RTOIngredient *ingredient = self.ratio.ingredients[indexPath.item-1];
        rcc.quantity.text = [ingredient.amountInRecipe.quantity stringValue];
        [rcc.unitButton setTitle:[ingredient.amountInRecipe.unit capitalizedString] forState:UIControlStateNormal];
        rcc.ingredientLabel.text = [ingredient.name capitalizedString];
        rcc.ratioPieView.ratio = self.ratio;
        rcc.ratioPieView.indexPath = indexPath;
        rcc.delegate = self;
    }
    return cell;
}

- (void)calculationRow:(RTOCacluationCell *)sender updatedUnitTo:(NSString *)unit
{
    NSIndexPath *indexPath = [self.calculateTableView indexPathForCell:sender];
    RTOIngredient *ingredient = self.ratio.ingredients[indexPath.item-1];
    [ingredient setRecipeUnits:unit];
    [self.calculateTableView reloadData];
}

#pragma mark Collection View

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.ratioCollectionView dequeueReusableCellWithReuseIdentifier:indexPath.item == 0 ? @"Ratio" : @"List" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[RTORatioCVC class]]) {
        RTORatioCVC *rcvc = (RTORatioCVC *)cell;
        rcvc.ratioPieView.ratio = self.ratio;
    } else if ([cell isKindOfClass:[RTOListCVC class]]) {
        RTOListCVC *lcvc = (RTOListCVC *)cell;
        lcvc.ratioPieView.ratio = self.ratio;
        lcvc.ratioPieView.indexPath = indexPath;
        lcvc.ingredientLabel.text = [[((RTOIngredient *)self.ratio.ingredients[indexPath.item-1]) description] capitalizedString];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = self.view.bounds.size.width, h = indexPath.item == 0 ? 220 : 30;
    return CGSizeMake(w, h);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.ratio.ingredients count] + 1;
}

#pragma mark View Life Cycle

- (void)setup
{
    NSMutableParagraphStyle *head = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    head.alignment = NSTextAlignmentCenter;
    head.paragraphSpacing = 14;
    NSMutableParagraphStyle *body = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    body.paragraphSpacing = 14;
    body.lineSpacing = 7;
    
    NSDictionary *headStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Black Oblique" size:17],
                                NSParagraphStyleAttributeName: head,
                                NSKernAttributeName: [NSNumber numberWithInt:1]};
    NSDictionary *bodyStyle = @{NSParagraphStyleAttributeName : body};
    NSMutableAttributedString *instructionsTxt = [[NSMutableAttributedString alloc] initWithString:@"Instructions\n" attributes:headStyle];
    NSArray *paragraphs = [self.ratio.instructions componentsSeparatedByString:@"\n"];
    [instructionsTxt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"•  %@", [paragraphs componentsJoinedByString:@"\n•  "]] attributes:bodyStyle]];
    [instructionsTxt appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nVariations\n" attributes:headStyle]];
    paragraphs = [self.ratio.variations componentsSeparatedByString:@"\n"];
    [instructionsTxt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"•  %@", [paragraphs componentsJoinedByString:@"\n•  "]] attributes:bodyStyle]];
    
    self.instructionsTextView.attributedText = instructionsTxt;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.calculateTableView.layer.position = CGPointMake(self.calculateTableView.layer.position.x + self.view.bounds.size.width, self.calculateTableView.layer.position.y);
    self.instructionsTextView.layer.position = CGPointMake(self.instructionsTextView.layer.position.x + 2 * self.view.bounds.size.width, self.instructionsTextView.layer.position.y);
    [self changeRatioViewWithIndex:self.viewSelectSegmentedControl.selectedSegmentIndex animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
    self.calculateTableView.alpha = 1;
    self.instructionsTextView.alpha = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setup];
    self.calculateTableView.alpha = 0;
    self.instructionsTextView.alpha = 0;
    
}


@end

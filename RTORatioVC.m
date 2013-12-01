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
#import "UIColor+RGB.h"

@interface RTORatioVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, RTOCalculationDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UIActionSheet *unitsSheet;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipe;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipe;
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UIButton *amountButton;
=======
@property (weak, nonatomic) IBOutlet UIView *calculationOuterView;
>>>>>>> 8267f885b646ce404b4846adfe5155b6c6fbad95
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
<<<<<<< HEAD
        ta.fromValue = [NSValue valueWithCATransform3D:self.calculateView.layer.transform];
        ta.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.calculateView.layer.bounds.origin.x + dx, dy, 0)];
=======
        ta.fromValue = [NSValue valueWithCATransform3D:self.calculationOuterView.layer.transform];
        ta.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.calculationOuterView.layer.bounds.origin.x + dx, dy, 0)];
>>>>>>> 8267f885b646ce404b4846adfe5155b6c6fbad95
        
        CABasicAnimation *txta = [CABasicAnimation animationWithKeyPath:@"transform"];
        txta.autoreverses = NO;
        txta.duration = ANIMATION_DURATION;
        txta.fromValue = [NSValue valueWithCATransform3D:self.instructionsTextView.layer.transform];
        txta.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.instructionsTextView.layer.bounds.origin.x + dx, dy, 0)];
        
        [self.ratioCollectionView.layer addAnimation:ra forKey:nil];
<<<<<<< HEAD
        [self.calculateView.layer addAnimation:ta forKey:nil];
=======
        [self.calculationOuterView.layer addAnimation:ta forKey:nil];
>>>>>>> 8267f885b646ce404b4846adfe5155b6c6fbad95
        [self.instructionsTextView.layer addAnimation:txta forKey:nil];
    }
    
    self.ratioCollectionView.layer.transform = CATransform3DMakeTranslation(self.ratioCollectionView.layer.bounds.origin.x + dx, 0, 0);
<<<<<<< HEAD
    self.calculateView.layer.transform = CATransform3DMakeTranslation(self.calculateView.layer.bounds.origin.x + dx, 0, 0);
=======
    self.calculationOuterView.layer.transform = CATransform3DMakeTranslation(self.calculationOuterView.layer.bounds.origin.x + dx, 0, 0);
>>>>>>> 8267f885b646ce404b4846adfe5155b6c6fbad95
    self.instructionsTextView.layer.transform = CATransform3DMakeTranslation(self.instructionsTextView.layer.bounds.origin.x + dx, 0, 0);
}

- (void)changeViewWithSwipe:(UISwipeGestureRecognizer *)sender
{
    NSInteger starting = self.viewSelectSegmentedControl.selectedSegmentIndex;
    switch (sender.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            if (self.viewSelectSegmentedControl.selectedSegmentIndex < 2) self.viewSelectSegmentedControl.selectedSegmentIndex++;
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            if (self.viewSelectSegmentedControl.selectedSegmentIndex > 0) self.viewSelectSegmentedControl.selectedSegmentIndex--;
            break;
            
        default:
            break;
    }
    
    if (starting != self.viewSelectSegmentedControl.selectedSegmentIndex) {
        [self changeRatioView];
    }
    
}

- (IBAction)updateTotal:(UIStepper *)sender
{
    self.ratio.totalQuantity = sender.value;
}

#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.ratio.ingredients count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            cellIdentifier = @"calcHeading";
        } else if (indexPath.item > [self.ratio.ingredients count]) {
            cellIdentifier = @"saveRow";
        } else {
            cellIdentifier = @"calcRow";
        }
    } else {
        cellIdentifier = @"variationRow";
    }
    UITableViewCell *cell = [self.calculateTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ([cell isKindOfClass:[RTOCacluationCell class]]) {
        RTOCacluationCell *rcc = (RTOCacluationCell *)cell;
        RTOIngredient *ingredient = self.ratio.ingredients[indexPath.item-1];
        rcc.quantity.text = [ingredient.amountInRecipe quantityAsString];
        rcc.quantity.placeholder = rcc.quantity.text;
        rcc.quantity.inputAccessoryView = [self inputAccessoryView:rcc.quantity];
        rcc.quantity.delegate = self;
        [rcc.unitButton setTitle:[ingredient.amountInRecipe.unit capitalizedString] forState:UIControlStateNormal];
        rcc.ingredientLabel.text = [ingredient.name capitalizedString];
        rcc.ingredientLabel.alpha = [[ingredient.amountInRecipe.unit capitalizedString] isEqualToString:rcc.ingredientLabel.text] ? 0 : 1;
        rcc.ratioPieView.ratio = self.ratio;
        rcc.ratioPieView.indexPath = indexPath;
        rcc.delegate = self;
        if (indexPath.item == [self.ratio.ingredients count]) {
            rcc.separatorInset = UIEdgeInsetsZero;
            rcc.indentationLevel = 0;
        }
    }
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    
//}

- (UIView *)inputAccessoryView:(UITextField *)sender {
    CGRect accessFrame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, 44.0);
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
    inputAccessoryView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UIButton *compButton = [UIButton buttonWithType:UIButtonTypeSystem];
    compButton.frame = CGRectMake(self.view.bounds.size.width - 88.0, 5.0, 70.0, 34.0);
    [compButton setTitle: @"Done" forState:UIControlStateNormal];
    [compButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [compButton setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    [compButton addTarget:sender action:@selector(resignFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:compButton];
    return inputAccessoryView;
}

- (void)calculationRow:(RTOCacluationCell *)sender updatedUnitTo:(NSString *)unit
{
    NSIndexPath *indexPath = [self.calculateTableView indexPathForCell:sender];
    [self.ratio.ingredients[indexPath.item-1] setRecipeUnits:unit];
    [self.calculateTableView reloadData];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    UIView *parentCell = textField.superview;
    while (parentCell.superview && ![parentCell isKindOfClass:[RTOCacluationCell class]]) {
        parentCell = parentCell.superview;
    }
    
    if (parentCell.superview) {
        NSIndexPath *indexPath = [self.calculateTableView indexPathForCell:(RTOCacluationCell *)parentCell];
        RTOIngredient *updated = self.ratio.ingredients[indexPath.item-1];
        CGFloat ratio = [textField.text floatValue] / [updated.amountInRecipe.quantity floatValue];
        for (RTOIngredient *i in self.ratio.ingredients) {
            i.amountInRecipe.quantity = [NSNumber numberWithFloat:[i.amountInRecipe.quantity floatValue] * ratio];
        }
        [self reloadData];
    }
}

- (void)reloadData
{
    [self.calculateTableView reloadData];
    [self.amountButton setTitle:[[self.ratio totalAsString] uppercaseString] forState:UIControlStateNormal];
}

- (IBAction)saveVariation
{
}

- (IBAction)showChangeAmount
{
#define chageHeight 44
    CGRect frame = CGRectMake(0, CGRectGetMaxX(self.amountButton.bounds), CGRectGetWidth(self.view.bounds), chageHeight);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor redColor];
    [self.calculateView insertSubview:view belowSubview:self.amountButton];
    
    CATransform3D transform = CATransform3DMakeTranslation(0, chageHeight, 0);
    
    CABasicAnimation *ra = [CABasicAnimation animationWithKeyPath:@"transform"];
    ra.autoreverses = NO;
    ra.duration = ANIMATION_DURATION;
    ra.fromValue = [NSValue valueWithCATransform3D:self.calculateTableView.layer.transform];
    ra.toValue = [NSValue valueWithCATransform3D:transform];
    [self.calculateTableView.layer addAnimation:ra forKey:nil];
    self.calculateTableView.layer.transform = transform;
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
    
    // TODO move to view controller for UITextView
    
    NSMutableParagraphStyle *head = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    head.alignment = NSTextAlignmentCenter;
    head.paragraphSpacing = 14;
    NSMutableParagraphStyle *body = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    body.paragraphSpacing = 14;
    body.lineSpacing = 3.5;
    
    NSDictionary *headStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Avenir Black Oblique" size:15],
                                NSParagraphStyleAttributeName: head,
                                NSKernAttributeName: [NSNumber numberWithInt:1],
                                NSForegroundColorAttributeName: [UIColor colorForR:255 G:27 B:28 A:1]};
    NSDictionary *bodyStyle = @{NSParagraphStyleAttributeName : body,
                                NSFontAttributeName: [UIFont fontWithName:@"Avenir Light" size:14]};
    NSMutableAttributedString *instructionsTxt = [[NSMutableAttributedString alloc] initWithString:@"INSTRUCTIONS\n" attributes:headStyle];
    NSArray *paragraphs = [self.ratio.instructions componentsSeparatedByString:@"\n"];
    [instructionsTxt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"•  %@", [paragraphs componentsJoinedByString:@"\n•  "]] attributes:bodyStyle]];
    [instructionsTxt appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nVARIATIONS\n" attributes:headStyle]];
    paragraphs = [self.ratio.variations componentsSeparatedByString:@"\n"];
    [instructionsTxt appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"•  %@", [paragraphs componentsJoinedByString:@"\n•  "]] attributes:bodyStyle]];
    
    self.instructionsTextView.attributedText = instructionsTxt;
    
    
    // TODO move to view controller for UITableView
    [self.amountButton setTitle:[[self.ratio totalAsString] uppercaseString] forState:UIControlStateNormal];
    self.amountButton.enabled = [self.ratio canSetAmountByTotal];
    
    // This has to stay at this level
    self.rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeViewWithSwipe:)];
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    self.leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeViewWithSwipe:)];
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:self.rightSwipe];
    [self.view addGestureRecognizer:self.leftSwipe];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
<<<<<<< HEAD
    self.calculateView.layer.position = CGPointMake(self.calculateView.layer.position.x + self.view.bounds.size.width, self.calculateView.layer.position.y);
=======
    self.calculationOuterView.layer.position = CGPointMake(self.calculationOuterView.layer.position.x + self.view.bounds.size.width, self.calculationOuterView.layer.position.y);
>>>>>>> 8267f885b646ce404b4846adfe5155b6c6fbad95
    self.instructionsTextView.layer.position = CGPointMake(self.instructionsTextView.layer.position.x + 2 * self.view.bounds.size.width, self.instructionsTextView.layer.position.y);
    [self changeRatioViewWithIndex:self.viewSelectSegmentedControl.selectedSegmentIndex animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];    
<<<<<<< HEAD
    self.calculateView.alpha = 1;
=======
    self.calculationOuterView.alpha = 1;
>>>>>>> 8267f885b646ce404b4846adfe5155b6c6fbad95
    self.instructionsTextView.alpha = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setup];
<<<<<<< HEAD
    self.calculateView.alpha = 0;
=======
    self.calculationOuterView.alpha = 0;
>>>>>>> 8267f885b646ce404b4846adfe5155b6c6fbad95
    self.instructionsTextView.alpha = 0;
    
}


@end

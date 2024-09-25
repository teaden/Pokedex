//
//  SegmentViewController.m
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

#import "SegmentViewController.h"

/**
 * Implementation details for SegmentViewController
 *
 * SegmentViewController handles swapping between TableView and CollectionView that use same Pokemon records
 */
@implementation SegmentViewController

// Hides TableView and shows CollectionView or vice versa based on SegmentedControl value
- (IBAction)changeSegment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.containerCollection.hidden = YES;
        self.containerTable.hidden = NO;
    } else {
        self.containerTable.hidden = YES;
        self.containerCollection.hidden = NO;
    }
}

// On initial view load set TableView as visible and CollectionView as hidden
- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerCollection.hidden = YES;
    self.containerTable.hidden = NO;
}

@end

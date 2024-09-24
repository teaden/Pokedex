//
//  SegmentViewController.m
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

#import "SegmentViewController.h"

@implementation SegmentViewController

- (IBAction)changeSegment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.containerCollection.hidden = YES;
        self.containerTable.hidden = NO;
    } else {
        self.containerTable.hidden = YES;
        self.containerCollection.hidden = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerCollection.hidden = YES;
    self.containerTable.hidden = NO;
}

@end

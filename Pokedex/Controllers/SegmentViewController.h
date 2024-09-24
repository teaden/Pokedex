//
//  SegmentViewController.h
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SegmentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (weak, nonatomic) IBOutlet UIView *containerTable;

@property (weak, nonatomic) IBOutlet UIView *containerCollection;


@end

NS_ASSUME_NONNULL_END

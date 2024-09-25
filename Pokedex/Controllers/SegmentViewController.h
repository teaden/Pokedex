//
//  SegmentViewController.h
//  Pokedex
//
//  Created by Tyler Eaden on 9/24/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Public interface for SegmentViewController
 *
 * SegmentViewController handles swapping between TableView and CollectionView that use same Pokemon records
 */
@interface SegmentViewController : UIViewController

// Outlet for the SegmentedControl used for swaps between TableView and CollectionView
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

// Outlet to UIView container for the TableView
@property (weak, nonatomic) IBOutlet UIView *containerTable;

// Outlet to UIView container for the collectionView
@property (weak, nonatomic) IBOutlet UIView *containerCollection;


@end

NS_ASSUME_NONNULL_END

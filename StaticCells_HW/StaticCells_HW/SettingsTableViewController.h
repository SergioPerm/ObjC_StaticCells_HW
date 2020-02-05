//
//  SettingsTableViewController.h
//  StaticCells_HW
//
//  Created by kluv on 05/02/2020.
//  Copyright © 2020 com.kluv.hw24. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingsTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldsCollection;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;


@end

NS_ASSUME_NONNULL_END

//
//  SettingsTableViewController.m
//  StaticCells_HW
//
//  Created by kluv on 05/02/2020.
//  Copyright © 2020 com.kluv.hw24. All rights reserved.
//

#import "SettingsTableViewController.h"

typedef enum {
    regFormLastName         = 7,
    regFormFirstName        = 1,
    regFormLogin            = 2,
    regFormPass             = 3,
    regFormAge              = 4,
    regFormPhone            = 5,
    regFormEmail            = 6,
    regFormAddress          = 11
} textFieldsTypes;

@interface SettingsTableViewController ()

@property (weak, nonatomic) UITextField* activeField;
@property (strong, nonatomic) NSMutableDictionary* keysSettingsDictionary;

@end

const NSString *SettingsFirstNameKey = @"firstName";
const NSString *SettingsLastNameKey = @"lastName";
const NSString *SettingsLoginKey = @"login";
const NSString *SettingsPasswordKey = @"password";
const NSString *SettingsAgeKey = @"age";
const NSString *SettingsPhoneKey = @"phone";
const NSString *SettingsEmailKey = @"email";
const NSString *SettingsAddressKey = @"address";

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField* firstTextField;
    
    for (UITextField* textField in self.textFieldsCollection) {
        
        if ([self.textFieldsCollection indexOfObject:textField] == 0) {
            firstTextField = textField;
        }
        
        textField.delegate = self;
        
    }
    
    [firstTextField becomeFirstResponder];
    
    [self setKeysForSettingsToTextFieldstypesDictionary];
      
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self loadSettings];
    
}

#pragma mark - Notifications

- (void)registerNotifications {
 
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(keyboardWillShow:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
 
}
 
- (void)deregisterNotifications {
 
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    
    [nc removeObserver:self
                  name:UIKeyboardWillShowNotification
                object:nil];
    
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    CGRect newFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, newFrame.size.height, 0);
    
    self.myTableView.contentInset = insets;
    self.myTableView.scrollIndicatorInsets = insets;
    
}

#pragma mark - Save and load methods

- (void) setKeysForSettingsToTextFieldstypesDictionary {
    
    self.keysSettingsDictionary = [NSMutableDictionary dictionary];
    
    [self.keysSettingsDictionary setObject:SettingsFirstNameKey forKey: [@(regFormFirstName) stringValue]];
    [self.keysSettingsDictionary setObject:SettingsLastNameKey forKey: [@(regFormLastName) stringValue]];
    [self.keysSettingsDictionary setObject:SettingsLoginKey forKey: [@(regFormLogin) stringValue]];
    [self.keysSettingsDictionary setObject:SettingsPasswordKey forKey: [@(regFormPass) stringValue]];
    [self.keysSettingsDictionary setObject:SettingsAgeKey forKey: [@(regFormAge) stringValue]];
    [self.keysSettingsDictionary setObject:SettingsPhoneKey forKey: [@(regFormPhone) stringValue]];
    [self.keysSettingsDictionary setObject:SettingsEmailKey forKey: [@(regFormEmail) stringValue]];
    [self.keysSettingsDictionary setObject:SettingsAddressKey forKey: [@(regFormAddress) stringValue]];
    
}

- (void) saveSettings {
        
    NSUserDefaults* userSettings = [NSUserDefaults standardUserDefaults];

    for (id key in self.keysSettingsDictionary) {
                
        NSInteger currentTag = [key integerValue];
        
        for (UITextField* currentTextField in self.textFieldsCollection) {
            
            if (currentTextField.tag == currentTag) {
             
                [userSettings setObject:currentTextField.text forKey:key];
                break;
                
            }
        }
            
    }
    
//    NSString* settingsKey = [self.keysSettingsDictionary objectForKey:[@(ctrltag) stringValue]];
//
//    [userSettings setObject:<#(nullable id)#> forKey:<#(nonnull NSString *)#>]
    
}

- (void) loadSettings {
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (id key in self.keysSettingsDictionary) {
    
        NSString* loadText = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:key]];
        
        NSInteger currentTag = [key integerValue];
       
        for (UITextField* currentTextField in self.textFieldsCollection) {
            
            if (currentTextField.tag == currentTag) {
                
                currentTextField.text = loadText;
                break;
                
            }
        }
        
    }
}

#pragma mark - Methods

- (void) setFirstRespronderForTextField:(UITextField*) textField {
    
    NSUInteger textFieldIndex = [self.textFieldsCollection indexOfObject:textField];

    if (textFieldIndex == self.textFieldsCollection.count - 1) {
        
        [textField resignFirstResponder];
        self.activeField = nil;
        
    } else {
        
        self.activeField = [self.textFieldsCollection objectAtIndex:textFieldIndex + 1];
        [self.activeField becomeFirstResponder];
        
    }
    
}

- (BOOL)validateEmailWithString:(NSString*)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

- (BOOL) validateEmail:(NSString *)emailString  {
 
    return [self validateEmailWithString:emailString];
    
}

- (BOOL) formatPhoneNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray *components = [newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    NSString *decimalString = [components componentsJoinedByString:@""];

    NSUInteger length = decimalString.length;
    BOOL hasLeadingEight = length > 0 && [decimalString characterAtIndex:0] == '8';

    if (length == 0 || (length > 10 && !hasLeadingEight) || (length > 11)) {
        textField.text = decimalString;
        return NO;
    }

    NSUInteger index = 0;
    NSMutableString *formattedString = [NSMutableString string];

    if (hasLeadingEight) {
        [formattedString appendString:@"8 "];
        index += 1;
    }

    if (length - index > 3) {
        NSString *areaCode = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"(%@) ",areaCode];
        index += 3;
    }

    if (length - index > 3) {
        NSString *prefix = [decimalString substringWithRange:NSMakeRange(index, 3)];
        [formattedString appendFormat:@"%@-",prefix];
        index += 3;
    }

    NSString *remainder = [decimalString substringFromIndex:index];
    [formattedString appendString:remainder];

    textField.text = formattedString;

    return NO;
    
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self setFirstRespronderForTextField:textField];
    
    return YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.activeField = textField;
    
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    [self saveSettings];
    
    if (textField.tag == regFormEmail) {
        
        BOOL validateEmail = [self validateEmail:textField.text];
        
        if (validateEmail) {
            
            [textField setTextColor:[UIColor blackColor]];
            
        } else {
            
            [textField setTextColor:[UIColor redColor]];
            
            return NO;
            
        }
    }
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == regFormPhone) {
        return [self formatPhoneNumber:textField shouldChangeCharactersInRange:range replacementString:string];
    }
        
    return YES;
    
}

@end

//
//  UIViewController+ZPPValidationCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "UIViewController+ZPPValidationCategory.h"
#import <REFormattedNumberField.h>
#import "UIView+UIViewCategory.h"

@implementation UIViewController (ZPPValidationCategory)
- (BOOL)checkPhoneTextField:(REFormattedNumberField *)textField {
    return textField.unformattedText.length == 10;
}

- (BOOL)checkNameTextField:(UITextField *)textField {
    NSString *candidate = textField.text;
    NSString *nameRegex = @"[A-Za-zА-Яа-я]{1,20}";  //([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameTest evaluateWithObject:candidate];

    // return textField.text.length;
}

- (BOOL)checkEmailTextField:(UITextField *)textField {
    NSString *candidate = textField.text;

    NSString *emailRegex =
        @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";  //([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:candidate];
}

- (BOOL)checkPasswordTextFied:(UITextField *)textField {
    return textField.text.length >= 6;
}

- (BOOL)checkPasswordEqualty:(UITextField *)firstField second:(UITextField *)secondTextField {
    return [firstField.text isEqualToString:secondTextField.text];
}



- (void)accentTextField:(UITextField *)tf {
    [tf shakeView];
    [tf becomeFirstResponder];
}
@end

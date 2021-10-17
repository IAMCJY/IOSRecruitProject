//
//  ViewController.m
//  Register
//
//  Created by JYCao on 2021/10/14.
//  Copyright © 2021 JYCao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
- (IBAction)signInOnClick:(id)sender;
- (IBAction)registerOnClick:(id)sender;
- (IBAction)confirmOnClick:(id)sender;
- (IBAction)cancelOnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *accoutField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *registerPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *registerAccountField;

@property (strong, nonatomic) IBOutlet UIView *secondView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _secondView.hidden = YES;
    // Do any additional setup after loading the view.
}


/* 警告弹窗 */

-(void)alertErrorView
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Error inputing accout number or password!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"Tap YES button");
    }];
    
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:true completion:nil];
}


-(void)alertCurrentView
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Sign in success!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"Tap YES button");
    }];
    
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:true completion:nil];
}


-(void)alertRegisterSuccessView
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Register success!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"Tap YES button");
    }];
    
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:true completion:nil];
}


-(void)alertRegisterFailureView
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Register failed!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        NSLog(@"Tap YES button");
    }];
    
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:true completion:nil];
}

/* ---------------- */


/* 按钮动作 */

- (IBAction)signInOnClick:(id)sender {
    NSString * accountString = [NSString stringWithContentsOfFile:@"/Users/c.j.y/Desktop/ios/Project/Register/accountNumber.rtf" encoding:NSUTF8StringEncoding error:NULL];
    NSString * passwordString = [NSString stringWithContentsOfFile:@"/Users/c.j.y/Desktop/ios/Project/Register/passwordNumber.rtf" encoding:NSUTF8StringEncoding error:NULL];
/*
    NSLog(@"%@", accountString);
    NSLog(@"%@", passwordString);
*/
    NSArray * accounts = [accountString componentsSeparatedByString:@"\n"];
    NSArray * passwords = [passwordString componentsSeparatedByString:@"\n"];
    
    NSMutableArray * temp = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < accounts.count; ++i) {
        NSString * string = [accounts[i] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        [temp addObject:string];
    }
    accounts = [temp copy];
    [temp removeAllObjects];
    for (NSInteger i = 0; i < passwords.count; ++i) {
        NSString * string = [passwords[i] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        [temp addObject:string];
    }
    passwords = [temp copy];
/*
    NSLog(@"%@", accounts[8]);
    NSLog(@"%@", passwords[8]);
*/
    NSInteger i = 8;
    for (; i < accounts.count - 1; ++i) {
        if ([_accoutField.text isEqualToString:accounts[i]]) {
            if ([_passwordField.text isEqualToString:passwords[i]])
                [self alertCurrentView];
            else
                [self alertErrorView];
        }
    }
    if (i >= accounts.count)
        [self alertErrorView];
}

- (IBAction)registerOnClick:(id)sender {
    _accoutField.text = NULL;
    _passwordField.text = NULL;
    _secondView.hidden = NO;
}

- (IBAction)confirmOnClick:(id)sender {
    NSString * accountString = [NSString stringWithContentsOfFile:@"/Users/c.j.y/Desktop/ios/Project/Register/accountNumber.rtf" encoding:NSUTF8StringEncoding error:NULL];

    NSArray * accounts = [accountString componentsSeparatedByString:@"\n"];
        
    NSMutableArray * temp = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < accounts.count; ++i) {
        NSString * string = [accounts[i] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        [temp addObject:string];
    }
    accounts = [temp copy];
    
    NSLog(@"%@", accounts[8]);
    
    NSInteger i = 8;
    for (; i < accounts.count - 1; ++i) {
        if ([_registerAccountField.text isEqualToString:accounts[i]]) {
            [self alertRegisterFailureView];
            break;
        }
    }
    
    if (i >= accounts.count - 1) {
        NSFileHandle * fileAccount = [NSFileHandle fileHandleForUpdatingAtPath:@"/Users/c.j.y/Desktop/ios/Project/Register/accountNumber.rtf"];
        NSFileHandle * filePassword = [NSFileHandle fileHandleForUpdatingAtPath:@"/Users/c.j.y/Desktop/ios/Project/Register/passwordNumber.rtf"];
        
        [fileAccount seekToEndOfFile];
        [filePassword seekToEndOfFile];
        [fileAccount writeData:[[_registerAccountField.text stringByAppendingFormat:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [filePassword writeData:[[_registerPasswordField.text stringByAppendingFormat:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileAccount closeFile];
        [filePassword closeFile];
        
        [self alertRegisterSuccessView];
    }
    
    _registerAccountField.text = NULL;
    _registerPasswordField.text = NULL;
}

- (IBAction)cancelOnClick:(id)sender {
    _registerAccountField.text = NULL;
    _registerPasswordField.text = NULL;
    _secondView.hidden = YES;
}

/* ---------------- */


/* 软键盘弹出和收起 */

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
}


-(void) keyboardDidShow: (NSNotification *)notification
{
    NSLog(@"键盘打开");
}

-(void) keyboardDidHide: (NSNotification *)notification
{
    NSLog(@"键盘关闭");
}

/* ------------------ */


#pragma mark
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

@end

//
//  RegisterController.m
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 9..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import "RegisterController.h"
#import "NSDataModel.h"

@interface RegisterController ()<UITextFieldDelegate>

@end

@implementation RegisterController
{
    NSDataModel* _mymodel;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _mymodel = [[NSDataModel alloc] init];
	// Do any additional setup after loading the view.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tap];
    
    _nickname.delegate = self;
    _password.delegate = self;
    _Email.delegate = self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _nickname || _Email) {
        [UIView beginAnimations:@"MyAnimation" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGRect newframe = self.view.frame;
        newframe.origin.y = -80;
        self.view.frame = newframe;
        [UIView commitAnimations];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _password) {
        [UIView beginAnimations:@"MyAnimation" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGRect newframe = self.view.frame;
        newframe.origin.y = 0;
        self.view.frame = newframe;
        [UIView commitAnimations];
    }
    return YES;
}

-(void)didTap:(UITapGestureRecognizer*)rec
{
    [self.nickname resignFirstResponder];
    [self.Email resignFirstResponder];
    [self.password resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)register:(id)sender {
        [_mymodel saveName:self.nickname.text Email:self.Email.text withPassword:self.password.text];
        
        NSLog(@"%@",[_mymodel description]);
}





@end

//
//  ViewController.m
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 7..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import "ViewController.h"
#import "NSDataModel.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSDataModel* _loginModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _loginModel=[[NSDataModel alloc]init];
    
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tap];

}

-(void)didTap:(UITapGestureRecognizer*)rec
{
    [self.logInMail resignFirstResponder];
    [self.logInPwd resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)identify:(id)sender {
    
//    NSLog(@"%hhd",[_loginModel authenticateEmail:self.logInMail.text withPassword:self.logInPwd.text]);
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL result = [_loginModel authenticateEmail:self.logInMail.text withPassword:self.logInPwd.text];

    if([identifier isEqualToString:@"logIn"]){
        
        return result;
    }
    return YES;
}

-(IBAction)returned:(UIStoryboardSegue*)segue{
}

@end

//
//  NXWriteViewController.m
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 18..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import "NXWriteViewController.h"
#import "NSDataModel.h"

@interface NXWriteViewController ()<UITextFieldDelegate, UITextViewDelegate>

@end

@implementation NXWriteViewController
{
    NSDataModel* _sendmodel;
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
    _sendImage.image = _internalImage;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tap];
    
    _sendTitle.delegate = self;
    _sendComment.delegate = self;
    
    _sendmodel = [[NSDataModel alloc] init];
	// Do any additional setup after loading the view.
}

-(void)didTap:(UITapGestureRecognizer*)rec
{
    [self.sendTitle resignFirstResponder];
    [self.sendComment resignFirstResponder];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _sendTitle) {
        [UIView beginAnimations:@"MyAnimation" context:nil];
        [UIView setAnimationDuration:0.6];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        CGRect newframe = self.view.frame;
        newframe.origin.y = -200;
        self.view.frame = newframe;
        [UIView commitAnimations];
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView == _sendComment) {
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"image: %@, title: %@, comment: %@",_sendImage.image, self.sendTitle.text, self.sendComment.text);
   
   [_sendmodel sendpicture:self.sendImage.image Title:self.sendTitle.text withComment:self.sendComment.text];

}

-(void)prepareData:(UIImage *)image
{
    _internalImage = image;
}

@end

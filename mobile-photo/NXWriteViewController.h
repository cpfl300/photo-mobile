//
//  NXWriteViewController.h
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 18..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXWriteViewController : UIViewController
{
    UIImage * _internalImage;
}

@property (weak, nonatomic) IBOutlet UIImageView *sendImage;
@property (weak, nonatomic) IBOutlet UITextField *sendTitle;
@property (weak, nonatomic) IBOutlet UITextView *sendComment;

- (void)prepareData:(UIImage*)image;
- (IBAction)sendButton:(id)sender;

@end

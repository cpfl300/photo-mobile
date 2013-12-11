//
//  showController.h
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 11..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface showController : UIViewController
@property NSDictionary* selectedData;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

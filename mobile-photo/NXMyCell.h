//
//  NXMyCell.h
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 11..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NXMyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@property (weak, nonatomic) IBOutlet UILabel *imageDescribe;

@end

//
//  showController.m
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 11..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import "showController.h"
#import "UIImageView+WebCache.h"

@interface showController ()

@end

@implementation showController

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
    self.subject.text = _selectedData[@"title"];
    
    NSString *url=@"http://localhost:8080/images/";
    if([[_selectedData objectForKey:@"fileName"] class] != [NSNull class]){
        url = [url stringByAppendingString:[_selectedData objectForKey:@"fileName"]];
    }else{
        url = @"http://localhost:8080/images/noimage.png";
    }
    [self.image setImageWithURL:[NSURL URLWithString:url]];
    self.discribe.text = _selectedData[@"comment"];
//    self.image = [UIImage imageNamed:[_selectedData objectForKey:[@"image"]]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

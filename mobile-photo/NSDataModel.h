//
//  NSDataModel.h
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 9..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDataModel : NSObject<NSURLConnectionDataDelegate>
@property UITableViewController* tableController; // tableView가 그려지는 시점을 조정하기 위해
-(void)saveName:(NSString*)nickname Email:(NSString*)email withPassword:(NSString*)password;
-(BOOL)authenticateEmail:(NSString*)email withPassword:(NSString*)password;
-(NSDictionary*)objectAtIndex:(NSInteger)index;
-(NSInteger)countData;

@end

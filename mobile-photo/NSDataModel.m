//
//  NSDataModel.m
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 9..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import "NSDataModel.h"
#define kNAME_KEY @"name"
#define kMAIL_KEY @"email"
#define kPWD_KEY @"pwd"


@implementation NSDataModel
{
    NSMutableDictionary* _loginData;
    NSMutableArray* _itemArray;
    NSMutableData *_responseData;
    
}

-(id)init{
    self=[super init];
    if(self)
    {
        _itemArray = [@[
                        @{@"text":@"첫번째", @"image":@"shutterstock_156666290.jpg"},
                        @{@"text":@"두번째", @"image":@"osaka_azmanga.jpg"},
                        @{@"text":@"세번째", @"image":@"goowoo.jpg"}
                        ] mutableCopy];
        _loginData = [[NSMutableDictionary alloc] initWithCapacity:3];
        
        _responseData = [[NSMutableData alloc] initWithCapacity:10];
        NSString *aURLString = @"http://1.234.2.8/board.php";
        NSURL *aURL = [NSURL URLWithString:aURLString];
        NSURLRequest *aRequest = [NSMutableURLRequest requestWithURL:aURL];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:YES];
    }
    return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    _itemArray = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:nil];
    [_tableController.tableView reloadData];
    NSLog(@"result json = %@", _itemArray);
}

-(void)saveName:(NSString *)nickname Email:(NSString *)email withPassword:(NSString *)password
{
    [_loginData setObject:nickname forKey:kNAME_KEY];
    [_loginData setObject:email forKey:kMAIL_KEY];
    [_loginData setObject:password forKey:kPWD_KEY];
    
}

-(BOOL)authenticateEmail:(NSString *)email withPassword:(NSString *)password
{
//    if([email isEqualToString:_loginData[kMAIL_KEY]] && [password isEqualToString:_loginData[kPWD_KEY]]){
//        return YES;
//    }
//     return NO;
    NSString *aURLString = @"http://1.234.2.8/login.php";
    NSString *aFormData = [NSString stringWithFormat:@"id=%@&passwd=%@",email,password]; //ios, ios
    NSURL *aURL = [NSURL URLWithString:aURLString];
    NSMutableURLRequest *aRequest = [NSMutableURLRequest requestWithURL:aURL];
    [aRequest setHTTPMethod:@"POST"];
    [aRequest setHTTPBody:[aFormData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *aResponse;
    NSError *aError;
    NSData *aResultData = [NSURLConnection sendSynchronousRequest:aRequest returningResponse:&aResponse error:&aError];
    
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:aResultData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"login response = %d", aResponse.statusCode); //aResponse의 결과는 통신이 성공했는지 여부
    NSLog(@"login result = %@", dataDictionary );
    if([dataDictionary[@"result"] isEqualToString:@"OK"]){
        return YES;
    }
    return NO;
}

-(NSString*)description
{
    return _loginData.description;
}

-(NSDictionary*)objectAtIndex:(NSInteger)index
{
    return _itemArray[index];
}

-(NSInteger)countData
{
    NSLog(@"%d", _itemArray.count);
    return _itemArray.count;
}

@end

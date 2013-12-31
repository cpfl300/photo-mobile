//
//  NSDataModel.m
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 9..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import "NSDataModel.h"
#import <ImageIO/CGImageSource.h>
#define kNAME_KEY @"name"
#define kMAIL_KEY @"email"
#define kPWD_KEY @"pwd"


@implementation NSDataModel
{
    NSMutableDictionary* _loginData;
    NSMutableArray* _itemArray;
    NSMutableDictionary* _itemDictionary;
    NSMutableData *_responseData;
    
}

-(id)init{
    self=[super init];
    if(self)
    {
//        _itemArray = [@[
//                        @{@"text":@"첫번째", @"image":@"shutterstock_156666290.jpg"},
//                        @{@"text":@"두번째", @"image":@"osaka_azmanga.jpg"},
//                        @{@"text":@"세번째", @"image":@"goowoo.jpg"}
//                        ] mutableCopy];
        _loginData = [[NSMutableDictionary alloc] initWithCapacity:3];
        
        _responseData = [[NSMutableData alloc] initWithCapacity:10];
//        NSString *aURLString = @"http://1.234.2.8/board.php";
        NSString* aURLString = @"http://localhost:8080/board/list.json";
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
    _itemDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:NSJSONReadingMutableContainers error:nil];
    [_tableController.tableView reloadData];
    NSLog(@"result json = %@", _itemDictionary);
    
}

//가입하기
-(void)saveName:(NSString *)nickname Email:(NSString *)email withPassword:(NSString *)password
{
    [_loginData setObject:nickname forKey:kNAME_KEY];
    [_loginData setObject:email forKey:kMAIL_KEY];
    [_loginData setObject:password forKey:kPWD_KEY];
    
    // register on server
    NSString *joinURLString = @"http://localhost:8080/join";
    NSString *joinData = [NSString stringWithFormat:@"userId=%@&userEmail=%@&password=%@",nickname,email,password];
    NSURL *joinURL = [NSURL URLWithString:joinURLString];
    NSMutableURLRequest *joinRequest = [NSMutableURLRequest requestWithURL:joinURL];
    [joinRequest setHTTPMethod:@"POST"];
    [joinRequest setHTTPBody:[joinData dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSHTTPURLResponse *joinResponse;
    NSError *joinError;
    NSData *joinResult = [NSURLConnection sendSynchronousRequest:joinRequest returningResponse:&joinResponse error:&joinError];
    
//    NSDictionary *joinDataDic=[NSJSONSerialization JSONObjectWithData:joinResult options:NSJSONReadingMutableContainers error:Nil];
    NSLog(@"join response = %d", joinResponse.statusCode); //통신 성공?
//    NSLog(@"join result = %@",joinDataDic);
}

-(void)sendpicture:(UIImage *)image Title:(NSString *)title withComment:(NSString *)comment{
    
    NSDateFormatter *time = [[NSDateFormatter alloc]init];
    [time setDateFormat:@"yyMMddHHmmss"];
    NSString *curDatetime = [time stringFromDate:[NSDate date]];
    NSLog(@"현재시간은!!!%@", curDatetime);
    NSString* fileName = curDatetime;
    
    NSString *submitURLString = @"http://localhost:8080/board/board.json";
    NSURL *submitURL = [NSURL URLWithString:submitURLString];
    NSMutableURLRequest *submitRequest = [NSMutableURLRequest requestWithURL:submitURL];
    [submitRequest setHTTPMethod:@"POST"]; // default는 GET
    
    NSString *boundary = @"------dnsjgysmssjanrnlduqek------";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [submitRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"%@\r\n", title] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"%@\r\n", comment] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    if(imgData){
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.jpg\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postBody appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:imgData];
        [postBody appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [submitRequest setHTTPBody:postBody];
 //   [submitRequest setURL:submitURL];
    
    /*
    //url setup
    NSString *submitURLString = @"http://localhost:8080/board/board.json";
    NSURL *submitURL = [NSURL URLWithString:submitURLString];
    NSMutableURLRequest *submitRequest = [NSMutableURLRequest requestWithURL:submitURL];
    [submitRequest setHTTPMethod:@"POST"]; // default는 GET
    
    NSString *boundary = @"------dnsjgysmssjanrnlduqek------";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [submitRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableData *postBody = [NSMutableData data];
    
    //title append
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disopsition: form-data; name=\"title\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[title dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // comment append
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithString:@"Content-Disopsition: form-data; name=\"comment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[comment dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //image append
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"testImage.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //image를 NSdata로 넣기
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0);
    //add it to body
    [postBody appendData:imgData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
   
    //final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [submitRequest setHTTPBody:postBody];
    
    **/
    NSHTTPURLResponse *submitResponse;
    NSError *submitError;
    NSData *submitResult = [NSURLConnection sendSynchronousRequest:submitRequest returningResponse:&submitResponse error:&submitError];
    NSLog(@"submit response = %d", submitResponse.statusCode); //통신 성공여부
    


    
//    NSString *submitURLString = @"http://localhost:8080/board/board.json";
//    NSURL *submitURL = [NSURL URLWithString:submitURLString];
//    NSMutableURLRequest *submitRequest = [NSMutableURLRequest requestWithURL:submitURL];
//    [submitRequest setHTTPMethod:@"POST"];
//    
//    
//    NSString *boundary = @"------dnsjgysmssjanrnlduqek------";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//    [submitRequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
//    NSMutableData *body = [NSMutableData data];
//    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [body appendData:[@"Content-disposition: form-data; name=\"userfile\"; filename=\"Test.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    
//    
//    NSString *submitData;// 여기서 데이터를 보낼 것. NSDATA형식의 사진과, NSString의 글2개
//    [submitRequest setHTTPBody:[submitData dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSHTTPURLResponse *submitResponse;
//    NSError *submitError;
//    NSData *submitResult = [NSURLConnection sendSynchronousRequest:submitRequest returningResponse:&submitResponse error:&submitError];
//    NSLog(@"submit response = %d", submitResponse.statusCode); //통신 성공여부
}

-(BOOL)authenticateEmail:(NSString *)email withPassword:(NSString *)password
{
//    if([email isEqualToString:_loginData[kMAIL_KEY]] && [password isEqualToString:_loginData[kPWD_KEY]]){
//        return YES;
//    }
//     return NO;
    NSString *aURLString = @"http://localhost:8080/login/login.json";
    NSString *aFormData = [NSString stringWithFormat:@"userEmail=%@&password=%@",email,password]; //ios, ios
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
    return _itemDictionary[@"iterator"][index];
}

-(NSInteger)countData
{
    NSArray* arr = [_itemDictionary objectForKey: @"iterator"];
    NSLog(@"Count: %d",arr.count);
    
    return arr.count;
}

@end

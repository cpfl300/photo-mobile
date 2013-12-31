//
//  TableViewController.m
//  mobile-photo
//
//  Created by 김민주 on 2013. 12. 9..
//  Copyright (c) 2013년 김민주. All rights reserved.
//

#import "TableViewController.h"
#import "NSDataModel.h"
#import "showController.h"
#import "NXMyCell.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "CLImageEditor.h"
#import "NXWriteViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface TableViewController ()<UIImagePickerControllerDelegate, CLImageEditorDelegate>

@end

@implementation TableViewController
{
    NSDataModel* _dataModel;
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
	// Do any additional setup after loading the view.
    _dataModel = [[NSDataModel alloc]init];
    _dataModel.tableController = self; //_dataModel을 통해서 다시 그려주는 tableController로 접근해서 나(self)를 다시 그려달라고 함.
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(newImage:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

-(void)viewDidAppear:(BOOL)animated
{

    _dataModel = [[NSDataModel alloc]init];
    _dataModel.tableController = self;
}

- (void)newImage:(id)sender
{
    UIImagePickerController *picker
    = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self.navigationController
     presentViewController:picker animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = [info objectForKey:
                           UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(__bridge id)kUTTypeImage])
    {
        UIImage* aImage = [info
                           objectForKey:UIImagePickerControllerOriginalImage];
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:aImage];
        editor.delegate = self;
        [picker pushViewController:editor animated:YES];
        
//        UIAlertView *alertView1 = [[UIAlertView alloc]
//                                   initWithTitle:@"이미지" message:@"골랐어요" delegate:self
//                                   cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
//        alertView1.alertViewStyle = UIAlertViewStyleDefault;
//        [alertView1 show];
    }
}

- (void)imageEditor:(CLImageEditor *)editor
didFinishEdittingWithImage:(UIImage *)image
{
    NXWriteViewController* writeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"forSend"];
    [writeVC prepareData:image];
    [editor dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController pushViewController:writeVC animated:NO];
    
    //[editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataModel countData];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = [_dataModel objectAtIndex:indexPath.row];
    NXMyCell *cell = [tableView dequeueReusableCellWithIdentifier:
                      @"listCell"];
    cell.imageTitle.text = [item objectForKey:@"title"];
    cell.imageDescribe.text = [item objectForKey:@"comment"];
    
    if ([[item objectForKey:@"fileName"] class] != [NSNull class])
    {
        NSString *url=@"http://localhost:8080/images/";
        url = [url stringByAppendingString:[item objectForKey:@"fileName"]];
        [cell.image setImageWithURL:[NSURL URLWithString:url]];
    }
    else{
        NSString *url = @"http://localhost:8080/images/noimage.png";
        [cell.image setImageWithURL:[NSURL URLWithString:url]];
    };
    
    
//    cell.image.image = [UIImage imageNamed:[item objectForKey:@"fileName"]];
    
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//    cell.textLabel.text = [item objectForKey:@"text"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SELECTED INFO= %@", [_dataModel objectAtIndex:indexPath.row]);
    [self performSegueWithIdentifier:@"show" sender:self];
    
}

// segue가 불리기 전에 이 메소드가 불려요!
// segue.destinationViewController는 다음 segue를 가리켜요!
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    showController *destination = segue.destinationViewController;
    NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
    destination.selectedData = [_dataModel objectAtIndex:indexpath.row];
}

-(IBAction)returnList:(UIStoryboardSegue*)segue{
}


@end

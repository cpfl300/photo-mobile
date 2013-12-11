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

@interface TableViewController ()

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
    cell.imageTitle.text = [item objectForKey:@"content"];
//    cell.imageDescribe.text = [item objectForKey:@"image"];
    [cell.image setImageWithURL:[NSURL URLWithString:[item objectForKey:@"image"]]];
//    cell.image.image = [UIImage imageNamed:[item objectForKey:@"image"]];
    
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




@end

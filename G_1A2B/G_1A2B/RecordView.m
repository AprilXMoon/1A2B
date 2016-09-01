//
//  RecordView.m
//  G_1A2B
//
//  Created by AprilXMoon on 2014/9/17.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "RecordView.h"
#import "EntityControl.h"

@interface RecordView () <UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray *RecordsArr;
}

@property (retain,nonatomic) IBOutlet UITableView *RecordsTableV;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation RecordView

- (instancetype)initWithFrame:(CGRect)frame owner:(id)owner
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"RecordView" owner:owner options:nil] objectAtIndex:0];
    if (self) {
        RecordsArr = [[EntityControl shareEntityControl]GetAllRecords];
        self.RecordsTableV.dataSource = self;
        
        [self viewskin];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - view skin

- (void)viewskin
{
    NSArray *colors = @[ (id)[[UIColor colorWithRed:0.9757 green:1.0 blue:0.6802 alpha:1.0] CGColor],
                        (id)[[UIColor colorWithRed:0.9906 green:0.8731 blue:0.6414 alpha:1.0] CGColor]];
    
    CAGradientLayer *viewlayer = [CAGradientLayer layer];
    viewlayer.colors = colors;
    viewlayer.frame = _contentView.bounds;
    
    [_contentView.layer insertSublayer:viewlayer atIndex:0];
    
     _contentView.layer.cornerRadius = 5.0;
     _contentView.clipsToBounds = YES;
}

#pragma mark - Button Action

-(IBAction)CancelBtnPressed:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)DeleteBtnPressed:(id)sender
{
    UIAlertView *DeleteAlertView = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Delete all records?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [DeleteAlertView show];
}

#pragma mark - AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[EntityControl shareEntityControl] DeleteAllObject];
        
        RecordsArr = [[EntityControl shareEntityControl]GetAllRecords];
        [_RecordsTableV reloadData];
    }
}

#pragma mark - Records TableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RecordsArr.count + 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellNameIdentifier = @"RecordsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellNameIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellNameIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Question";
        cell.detailTextLabel.text = @"spend time.";
    } else {
        Records *record = [RecordsArr objectAtIndex:indexPath.row-1];
        cell.textLabel.text = record.answer;
        cell.detailTextLabel.text = record.time;
    }
    
    return cell;
}

@end

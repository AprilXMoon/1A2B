//
//  RecordView.m
//  G_1A2B
//
//  Created by AprilXMoon on 2014/9/17.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "RecordView.h"

@implementation RecordView

@synthesize RecordsTableV = _RecordsTableV;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
    //tset2
}

- (id) initCenterPoint:(CGPoint)CenterPoint
{
    UINib *nib = [UINib nibWithNibName:@"RecordView" bundle:nil];
    NSArray * array;
    array = [nib instantiateWithOwner:nil options:nil];
    
    self = (RecordView *) [array lastObject];
    
    if (self) {
        self.autoresizingMask = UIViewAutoresizingNone;
        self.center = CenterPoint;
        
        RecordsArr = [[EntityControl shareEntityControl]GetAllRecords];
        self.RecordsTableV.dataSource = self;
    
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

#pragma mark Button Action

-(IBAction)CancelBtnPressed:(id)sender
{
    [self removeFromSuperview];
}

-(IBAction)DeleteBtnPressed:(id)sender
{
    UIAlertView *DeleteAlertView = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Delete all records?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    [DeleteAlertView show];
}

#pragma mark AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[EntityControl shareEntityControl] DeleteAllObject];
        
        RecordsArr = [[EntityControl shareEntityControl]GetAllRecords];
        [_RecordsTableV reloadData];
    }
}

#pragma mark Records TableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return RecordsArr.count;
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellNameIdentifier];
        
        Records *record = [RecordsArr objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Answer:%@    Time:%@",record.answer,record.time];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell;
}

@end

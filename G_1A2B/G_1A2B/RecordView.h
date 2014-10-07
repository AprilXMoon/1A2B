//
//  RecordView.h
//  G_1A2B
//
//  Created by AprilXMoon on 2014/9/17.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntityControl.h"

@interface RecordView : UIView <UITableViewDataSource,UIAlertViewDelegate>
{
    NSArray *RecordsArr;
}

@property(retain,nonatomic)IBOutlet UITableView *RecordsTableV;

- (id) initCenterPoint:(CGPoint)CenterPoint;


@end

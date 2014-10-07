//
//  EntityControl.h
//  G_1A2B
//
//  Created by AprilXMoon on 2014/9/16.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Records.h"

@interface EntityControl : NSObject

@property (retain,nonatomic)NSManagedObjectContext *managedObjectContext;

+(EntityControl *)shareEntityControl;

-(NSMutableArray *) GetAllRecords;

-(BOOL)InsertNewRecord:(NSDictionary *)DataDic;
-(void)DeleteAllObject;

@end

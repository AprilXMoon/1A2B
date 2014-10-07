//
//  EntityControl.m
//  G_1A2B
//
//  Created by AprilXMoon on 2014/9/16.
//  Copyright (c) 2014年 test. All rights reserved.
//

#import "EntityControl.h"

static EntityControl *shared = nil;

@implementation EntityControl

+(EntityControl *)shareEntityControl
{
    if (!shared) {
        shared = [[EntityControl alloc]init];
    }
    
    return shared;
}

-(NSMutableArray *) GetAllRecords
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *frequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Records" inManagedObjectContext:context];
    [frequest setEntity:entity];
    
    NSError *error;
    NSMutableArray *DataArr = [[NSMutableArray alloc]initWithArray:[context executeFetchRequest:frequest error:&error]];
    
    return DataArr;

}

-(BOOL)InsertNewRecord:(NSDictionary *)DataDic;
{
    BOOL isSucceed = YES;
    NSManagedObjectContext *context = self.managedObjectContext;
    
    Records *Score = [NSEntityDescription insertNewObjectForEntityForName:@"Records" inManagedObjectContext:context];
    Score.answer = [DataDic objectForKey:@"Answer"];
    Score.time = [DataDic objectForKey:@"Time"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"error =%@", error.description);
        isSucceed = NO;
    }
    
    return isSucceed;
}

-(void)DeleteAllObject
{
    NSArray *AllObjectArr = [self GetAllRecords];
    for (Records *record in AllObjectArr) {
        [self.managedObjectContext deleteObject:record];
        [self UpdateObject];
    }
}

-(void)UpdateObject
{
    NSError *error = nil;
    
    if ([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
        NSLog(@"CoreData save fault:%@,%@",error,([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
    }
}
@end

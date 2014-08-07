//
//  ME_SQLMassager.h
//  IOSMirror
//
//  Created by gaoluyangrc on 14-7-14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface ME_SQLMassager : NSObject
{
//    sqlite3 *_database;
}
@property (nonatomic ,assign) sqlite3 *database;
+ (instancetype)shareStance;

//会话列表
- (NSString *)dataFilePath;
//创建数据库
- (BOOL)createTable:(sqlite3 *)db;

- (BOOL)insertAppInfo:(NSMutableArray *)appsInfo;
- (BOOL)updagteAppInfo:(int)appId withIsHaveDownLoad:(int)haveDownload;

- (BOOL)deleteAllData;

- (NSMutableArray *)getAllData;

@end

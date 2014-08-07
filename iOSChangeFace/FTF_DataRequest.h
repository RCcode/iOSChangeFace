//
//  ME_DataRequest.h
//  IOSMirror
//
//  Created by gaoluyangrc on 14-7-4.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTF_Delegates.h"
@class AppDelegate;

@interface FTF_DataRequest : NSObject
{
    NSInteger requestTag;
}

@property (nonatomic ,weak) id <WebRequestDelegate> delegate;
@property (nonatomic ,strong) NSDictionary *valuesDictionary;//post的数据

- (id)initWithDelegate:(id<WebRequestDelegate>)request_Delegate;

//注册设备信息
- (void)registerToken:(NSDictionary *)dictionary withTag:(NSInteger)tag;
//版本更新
- (void)updateVersion:(NSString *)url withTag:(NSInteger)tag;
//更多应用
- (void)moreApp:(NSDictionary *)dictionary withTag:(NSInteger)tag;

@end

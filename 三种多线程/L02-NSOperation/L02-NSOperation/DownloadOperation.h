//
//  DownloadOperation.h
//  L02-NSOperation
//
//  Created by 王迎博 on 16/8/17.
//  Copyright © 2016年 王迎博. All rights reserved.
//  封装自己的图片下载器

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DownloadOperationDelegate <NSObject>

- (void)downloadFinishWithImage:(UIImage *)image;

@end


@interface DownloadOperation : NSOperation
//图片的url路径
@property (nonatomic, copy) NSString *imageUrl;
//代理
@property (nonatomic, assign) id<DownloadOperationDelegate> delegate;

- (id)initWithUrl:(NSString *)url delegate:(id<DownloadOperationDelegate>)delegate;

@end

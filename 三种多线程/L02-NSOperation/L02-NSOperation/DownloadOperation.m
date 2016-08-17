//
//  DownloadOperation.m
//  L02-NSOperation
//
//  Created by 王迎博 on 16/8/17.
//  Copyright © 2016年 王迎博. All rights reserved.
//

#import "DownloadOperation.h"

@implementation DownloadOperation
@synthesize delegate = _delegate;
@synthesize imageUrl = _imageUrl;

//初始化
- (id)initWithUrl:(NSString *)url delegate:(id<DownloadOperationDelegate>)delegate
{
    if (self = [super init]) {
        self.imageUrl = url;
        self.delegate = delegate;
    }
    return self;
}

//执行主任务
- (void)main
{
    //新建一个自动释放池,如果是异步执行操作，那么将无法访问到主线程的自动释放池
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        
        //获取图片数据
        NSURL *url = [NSURL URLWithString:self.imageUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        if (self.isCancelled) {
            url = nil;
            imageData = nil;
            return;
        }
        
        //初始化图片
        UIImage *image = [UIImage imageWithData:imageData];
        if (self.isCancelled) {
            image = nil;
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(downloadFinishWithImage:)]) {
            //把图片数据传回到主线程
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloadFinishWithImage:) withObject:image waitUntilDone:NO];
        }
    }
}



@end

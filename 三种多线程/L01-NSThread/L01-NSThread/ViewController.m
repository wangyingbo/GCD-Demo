//
//  ViewController.m
//  L01-NSThread
//
//  Created by 王迎博 on 16/8/17.
//  Copyright © 2016年 王迎博. All rights reserved.

//  http://blog.csdn.net/q199109106q/article/details/8565844

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化线程
    //[self initNSThread];
    
    //获取当前线程
    //[self getCurrentThread];
    
    //获取主线程
    //[self getMainThread];
    
    //暂停当前线程
    //[self stopCurrentThread];
    
    //线程间通信
    //[self communicationInThread];
}


/**
 *  线程间通信
 */
- (void)communicationInThread
{
    //1.在指定线程上执行操作
    //[self performSelector:@selector(run) onThread:thread withObject:nil waitUntilDone:YES];
    
    //2.在主线程上执行操作
    [self performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:YES];
    
    //3.在当前线程执行操作
    [self performSelector:@selector(run) withObject:nil];
}


/**
 *  暂停当前线程
 */
- (void)stopCurrentThread
{
    // 暂停2s
    [NSThread sleepForTimeInterval:2];
    
    // 或者
    NSDate *date = [NSDate dateWithTimeInterval:2 sinceDate:[NSDate date]];
    [NSThread sleepUntilDate:date];
}


/**
 *  获取主线程
 */
- (void)getMainThread
{
    //NSThread *main = [NSThread mainThread];
}


/**
 *  获取当前线程
 */
- (void)getCurrentThread
{
    //NSThread *current = [NSThread currentThread];
}


/**
 *  初始化线程
 */
- (void)initNSThread
{
    /** - (id)initWithTarget:(id)target selector:(SEL)selector object:(id)argument;
     *  selector ：线程执行的方法，这个selector最多只能接收一个参数
     *  target ：selector消息发送的对象
     *  argument : 传给selector的唯一参数，也可以是nil
     */
    
    //初始化线程
    SEL sel = @selector(run);
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:sel object:nil];
    //设置线程的优先级  (0.0 -1.0 1.0)
    thread.threadPriority = 1;
    //开启线程
    [thread start];
    
    //静态方法
    /**
     
     + (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(id)argument;
     
     [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
     // 调用完毕后，会马上创建并开启新线程
     
     */
    
    
    //隐式创建线程的方法
    /**
     
     [self performSelectorInBackground:@selector(run) withObject:nil];
     
     */
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

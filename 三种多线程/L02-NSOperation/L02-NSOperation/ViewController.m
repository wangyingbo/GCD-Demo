//
//  ViewController.m
//  L02-NSOperation
//
//  Created by 王迎博 on 16/8/17.
//  Copyright © 2016年 王迎博. All rights reserved.

//  http://blog.csdn.net/q199109106q/article/details/8565923
//  http://blog.csdn.net/q199109106q/article/details/8566222


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建执行操作NSInvocationOperation
    //[self initNSInvocationOperation];
    
    //创建NSBlockOperation
    //[self initNSBlockOperation];
    
    //创建NSOperation
    [self initNSOperation];
    
    
}


/**
 *  创建NSOperation
 */
- (void)initNSOperation
{
    //一个NSOperation对象可以通过调用start方法来执行任务，默认是同步执行的。也可以将NSOperation添加到一个NSOperationQueue(操作队列)中去执行，而且是异步执行的。
    /**
    //创建操作队列
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //添加NSOperation到NSOperationQueue
    //1.添加一个operation
    [queue addOperation:operation];
    //2.添加一组operation
    [queue addOperations:operations waitUntilFinished:NO];
    //3.添加一个block形式的operation
    [queue addOperationWithBlock:^() {
        NSLog(@"执行一个新的操作，线程：%@", [NSThread currentThread]);
    }];
     */
    
    
    /**
     *  添加NSOperation的依赖对象-当某个NSOperation对象依赖于其它NSOperation对象的完成时，就可以通过addDependency方法添加一个或者多个依赖的对象，只有所有依赖的对象都已经完成操作，当前NSOperation对象才会开始执行操作。另外，通过removeDependency方法来删除依赖对象;
     *  依赖关系不局限于相同queue中的NSOperation对象,NSOperation对象会管理自己的依赖, 因此完全可以在不同的queue之间的NSOperation对象创建依赖关系
     *  唯一的限制是不能创建环形依赖，比如A依赖B，B依赖A，这是错误的
     */
    //[operation2 addDependency:operation1];
    
    
    //依赖关系会影响到NSOperation对象在queue中的执行顺序
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"执行第1次操作，线程：%@", [NSThread currentThread]);
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^(){
        NSLog(@"执行第2次操作，线程：%@", [NSThread currentThread]);
    }];
    // operation1依赖于operation2
    [operation1 addDependency:operation2];
    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    
    
    /** 修改Operations的执行顺序
     *  对于添加到queue中的operations，它们的执行顺序取决于2点：
            1.首先看看NSOperation是否已经准备好：是否准备好由对象的依赖关系确定
            2.然后再根据所有NSOperation的相对优先级来确定。优先级等级则是operation对象本身的一个属性。默认所有operation都拥有“普通”优先级,不过可以通过setQueuePriority:方法来提升或降低operation对象的优先级。优先级只能应用于相同queue中的operations。如果应用有多个operation queue,每个queue的优先级等级是互相独立的。因此不同queue中的低优先级操作仍然可能比高优先级操作更早执行。
     *  注意：优先级不能替代依赖关系,优先级只是对已经准备好的 operations确定执行顺序。先满足依赖关系,然后再根据优先级从所有准备好的操作中选择优先级最高的那个执行。
     */
    
    
    /** 设置队列的最大并发操作数量
     *  队列的最大并发操作数量，意思是队列中最多同时运行几条线程
     *  虽然NSOperationQueue类设计用于并发执行Operations,你也可以强制单个queue一次只能执行一个Operation。setMaxConcurrentOperationCount:方法可以配置queue的最大并发操作数量。设为1就表示queue每次只能执行一个操作。不过operation执行的顺序仍然依赖于其它因素,比如operation是否准备好和operation的优先级等。因此串行化的operation queue并不等同于GCD中的串行dispatch queue
     */
    /**
     // 每次只能执行一个操作
     queue.maxConcurrentOperationCount = 1;
     // 或者这样写
     [queue setMaxConcurrentOperationCount:1];
     */
    
    
    /** 取消Operations
     *  一旦添加到operation queue,queue就拥有了这个Operation对象并且不能被删除,唯一能做的事情是取消。你可以调用Operation对象的cancel方法取消单个操作,也可以调用operation queue的cancelAllOperations方法取消当前queue中的所有操作
     */
    /**
     // 取消单个操作
     [operation cancel];
     // 取消queue中所有的操作
     [queue cancelAllOperations];
     */
    
    
    /**  等待Options完成
     *  为了最佳的性能,你应该设计你的应用尽可能地异步操作,让应用在Operation正在执行时可以去处理其它事情。如果需要在当前线程中处理operation完成后的结果,可以使用NSOperation的waitUntilFinished方法阻塞当前线程，等待operation完成。通常我们应该避免编写这样的代码,阻塞当前线程可能是一种简便的解决方案,但是它引入了更多的串行代码,限制了整个应用的并发性,同时也降低了用户体验。绝对不要在应用主线程中等待一个Operation,只能在第二或次要线程中等待。阻塞主线程将导致应用无法响应用户事件,应用也将表现为无响应。
     *  除了等待单个Operation完成,你也可以同时等待一个queue中的所有操作,使用NSOperationQueue的waitUntilAllOperationsAreFinished方法。注意：在等待一个 queue时,应用的其它线程仍然可以往queue中添加Operation,因此可能会加长线程的等待时间。
     */
    /**
     // 会阻塞当前线程，等到某个operation执行完毕
     //[operation waitUntilFinished];
     // 阻塞当前线程，等待queue的所有操作执行完毕
     [queue waitUntilAllOperationsAreFinished];
     */
    
    
    /**  暂停和继续queue
     *  如果你想临时暂停Operations的执行,可以使用queue的setSuspended:方法暂停queue。不过暂停一个queue不会导致正在执行的operation在任务中途暂停,只是简单地阻止调度新Operation执行。你可以在响应用户请求时,暂停一个queue来暂停等待中的任务。稍后根据用户的请求,可以再次调用setSuspended:方法继续queue中operation的执行
     */
    /**
     // 暂停queue
     [queue setSuspended:YES];
     // 继续queue
     [queue setSuspended:NO];
     */

}


/**
 *  创建NSBlockOperation
 */
- (void)initNSBlockOperation
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行了一个新的操作，线程:%@",[NSThread currentThread]);
    }];
    
    //通过addExecutionBlock方法添加block操作
    [operation addExecutionBlock:^() {
        NSLog(@"又执行了1个新的操作，线程：%@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^() {
        NSLog(@"又执行了1个新的操作，线程：%@", [NSThread currentThread]);
    }];
    [operation addExecutionBlock:^() {
        NSLog(@"又执行了1个新的操作，线程：%@", [NSThread currentThread]);
    }];
    
    //开始执行
    [operation start];
}


/**
 *  创建执行操作NSInvocationOperation
 */
- (void)initNSInvocationOperation
{
    //创建
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(run) object:nil];
    //开始执行任务（同步执行）
    [operation start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end

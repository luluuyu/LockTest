//
//  Person.m
//  LockTest
//
//  Created by 鲁志刚 on 16/8/16.
//  Copyright © 2016年 FEBA. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>
#import <pthread.h>

@interface Person ()

@property (nonatomic,strong) NSLock *lock;
@property (nonatomic,assign) OSSpinLock spinLock;
@property pthread_mutex_t mutex;

@end

@implementation Person

- (instancetype)init
{
    if (self = [super init]) {
        OSSpinLock spinlock = OS_SPINLOCK_INIT;
        self.spinLock = spinlock;

        pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
        self.mutex = mutex;
    }
    return self;
}

- (void)read
{
    [self testSynchronized];
}

- (void)testNSLock
{
    [self.lock lock];
    [self doWork];
    [self.lock unlock];
}

- (void)testSynchronized
{
    @synchronized (self) {
        [self doWork];
    }
}

- (void)testMutex
{
    pthread_mutex_lock(&_mutex);
    [self doWork];
    pthread_mutex_unlock(&_mutex);
}

- (void)testSpinLock
{
    OSSpinLockLock(&_spinLock);
    [self doWork];
    OSSpinLockUnlock(&_spinLock);
}

- (void)doWork
{
    self.i++;
//    NSLog(@"AA %d",self.i);
}


#pragma mark getters
- (NSLock *)lock
{
    if (_lock == nil) {
        _lock = [[NSLock alloc] init];
    }
    return _lock;
}

//- (NSMutableString *)i
//{
//    if (_i == nil) {
//        _i = [NSMutableString stringWithString:@"4"];
//    }
//    return _i;
//}

@end

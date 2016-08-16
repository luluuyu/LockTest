//
//  Person.h
//  LockTest
//
//  Created by 鲁志刚 on 16/8/16.
//  Copyright © 2016年 FEBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic,assign) int i;
- (void)testNSLock;
- (void)testSynchronized;
- (void)testSpinLock;
- (void)testMutex;
@end

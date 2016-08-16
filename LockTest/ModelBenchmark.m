//
//  ModelBenchmark.m
//  LockTest
//
//  Created by 鲁志刚 on 16/8/16.
//  Copyright © 2016年 FEBA. All rights reserved.
//

#import "ModelBenchmark.h"

@implementation ModelBenchmark

- (instancetype)initWithName:(NSString *)name benchmark:(double)benchmark
{
    if (self = [super init]) {
        self.name = name;
        self.benchmark = [NSString stringWithFormat:@"%.3f",benchmark];
    }
    return self;
}

@end

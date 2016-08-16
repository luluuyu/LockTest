//
//  ModelBenchmark.h
//  LockTest
//
//  Created by 鲁志刚 on 16/8/16.
//  Copyright © 2016年 FEBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelBenchmark : NSObject

- (instancetype)initWithName:(NSString *)name benchmark:(double)benchmark;

@property (nonatomic,copy) NSString  *name;
@property (nonatomic,copy) NSString  *benchmark;

@end

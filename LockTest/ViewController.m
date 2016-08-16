//
//  ViewController.m
//  LockTest
//
//  Created by 鲁志刚 on 16/8/16.
//  Copyright © 2016年 FEBA. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "ModelBenchmark.h"
typedef NS_ENUM(NSUInteger, TestType) {
    TestTypeNSLock = 0,
    TestTypeSynchronized = 1,
    TestTypeSpinLock = 2,
    TestTypeMutex = 3
};
@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) dispatch_queue_t queue1;
@property (nonatomic,strong) dispatch_queue_t queue2;
@property (nonatomic,strong) dispatch_queue_t queue3;
@property (nonatomic,strong) dispatch_queue_t queue4;
@property (nonatomic,strong) dispatch_queue_t queue5;

@property (nonatomic,strong) Person *person;

@property (nonatomic,assign) NSTimeInterval timeBegin;

@property (nonatomic,assign) int doneCount;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (strong,nonatomic) NSMutableArray *tableModels;

@property (nonatomic,assign) int testType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self addObserver:self forKeyPath:@"doneCount" options:NSKeyValueObservingOptionNew context:nil];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.autoresizesSubviews = false;
}

#pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    ModelBenchmark *model = [self modelForIndexPath:indexPath];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = model.benchmark;
    return cell;
}

#pragma mark TableView model
- (ModelBenchmark *)modelForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.tableModels.count) {
        return self.tableModels[indexPath.row];
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"doneCount"]) {
        int count = [[change objectForKey:@"new"] intValue];
        if (count == 5) {
            NSTimeInterval timeEnd = [[NSDate date] timeIntervalSince1970];
            NSLog(@"%d",self.person.i);
            NSLog(@"Time Spend %f", timeEnd - self.timeBegin);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ModelBenchmark *model = [[ModelBenchmark alloc] initWithName:[self currentTestTypeName] benchmark:timeEnd - self.timeBegin];
                if (model) {
                    [self.tableModels addObject:model];
                }
                
                [self.mainTable reloadData];
                
                self.testType++;
                if (self.testType < 4) {
                    [self nextTest];
                }
            });
        }
    }
}

- (IBAction)beginTest:(id)sender
{
    self.tableModels = [NSMutableArray array];
    
    Person *person = [Person new];
    self.person = person;
    self.testType = TestTypeNSLock;

    [self nextTest];
}

- (void)nextTest
{
    self.timeBegin = [[NSDate date] timeIntervalSince1970];
    self.doneCount = 0;
    self.person.i = 0;

    dispatch_async(self.queue1, ^{
        for (int i = 0; i < 1000000; i++) {
            [self test];
        }
        NSLog(@"1 - %@", [NSThread currentThread]);
        self.doneCount++;
    });
    dispatch_async(self.queue2, ^{
        for (int i = 0; i < 1000000; i++) {
            [self test];
        }
        NSLog(@"2 - %@", [NSThread currentThread]);
        self.doneCount++;
    });
    dispatch_async(self.queue3, ^{
        for (int i = 0; i < 1000000; i++) {
            [self test];
        }
        NSLog(@"3 - %@", [NSThread currentThread]);
        self.doneCount++;
    });
    dispatch_async(self.queue4, ^{
        for (int i = 0; i < 1000000; i++) {
            [self test];
        }
        NSLog(@"4 - %@", [NSThread currentThread]);
        self.doneCount++;
    });
    dispatch_async(self.queue5, ^{
        for (int i = 0; i < 1000000; i++) {
            [self test];
        }
        NSLog(@"5 - %@", [NSThread currentThread]);
        self.doneCount++;
    });

}

- (NSString *)currentTestTypeName
{
    NSString *string;
    if (self.testType == TestTypeNSLock) {
        string = @"NSLock";
    }else if (self.testType == TestTypeSynchronized) {
        string = @"Synchronized";
    }else if (self.testType == TestTypeSpinLock) {
        string = @"SpinLock";
    }else if (self.testType == TestTypeMutex) {
        string = @"Mutex";
    }
    return string;
}

- (void)test
{
    if (self.testType == TestTypeNSLock) {
        [self.person testNSLock];
    }else if (self.testType == TestTypeSynchronized) {
        [self.person testSynchronized];
    }else if (self.testType == TestTypeSpinLock) {
        [self.person testSpinLock];
    }else if (self.testType == TestTypeMutex) {
        [self.person testMutex];
    }
}

- (dispatch_queue_t)queue1
{
    if (_queue1 == nil) {
        _queue1 = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue1;
}

- (dispatch_queue_t)queue2
{
    if (_queue2 == nil) {
        _queue2 = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue2  ;
}

- (dispatch_queue_t)queue3
{
    if (_queue3 == nil) {
        _queue3 = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue3;
}

- (dispatch_queue_t)queue4
{
    if (_queue4 == nil) {
        _queue4 = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue4  ;
}

- (dispatch_queue_t)queue5
{
    if (_queue5 == nil) {
        _queue5 = dispatch_queue_create("com.alamofire.networking.session.manager.creation", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue5;
}

@end

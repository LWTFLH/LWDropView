//
//  ViewController.m
//  LWDropView
//
//  Created by 李伟 on 16/7/13.
//  Copyright © 2016年 TFLH. All rights reserved.
//

#import "ViewController.h"
#import "LWDropBoxView.h"
@interface ViewController ()<LWDropBoxDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"下拉选择";
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    LWDropBoxView *box = [[LWDropBoxView alloc] init];
       [box setControlsViewOriginx:50
                    ViewOriginy:100
                      TextWidth:140
             TextAndButtonHigth:30
                    ButtonWidth:20
                     TableHigth:100
                     Editortype:YES];
    box.textfiled.placeholder = @"输入账号";
    box.delegate = self;
    box.tag = 1000;
    
//    NSMutableArray *arr = [NSMutableArray arrayWithArray:@[@"13841302445", @"13866889999", @"18888881111", @"18866668888"]];
//   BOOL suc =  [arr writeToFile:[NSHomeDirectory()stringByAppendingString:@"/Documents/ll.plist"] atomically:YES];
//    
//    NSLog(@"%d,%@",suc,NSHomeDirectory());
    
  //  box.arr = arr;
    [self.view addSubview:box];
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil userInfo:@{@"phone":@"13841302222"}];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //     [[NSNotificationCenter defaultCenter] postNotificationName:@"update" object:nil userInfo:@{@"phone":@"13841308888"}];
        });
        
    
        
    });
    
}
- (void)selectAtIndex:(int)index WithLWDrooBox:(LWDropBoxView *)dropbox {
    NSLog(@"row==%d:%@", index,dropbox.arr[index]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    LWDropBoxView *box = (LWDropBoxView *)[self.view viewWithTag:1000];
    [box closeTableview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

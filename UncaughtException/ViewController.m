//
//  ViewController.m
//  UncaughtException
//
//  Created by lijian on 16/10/19.
//  Copyright © 2016年 lijian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnClickedCrash:(id)sender {
    
    NSArray *aryCrash = @[@"Crash1",@"Crash2"];
    NSString *str = aryCrash[2];
    NSLog(@"str = %@",str);
}
@end

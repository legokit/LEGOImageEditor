//
//  LGViewController.m
//  LEGOImageEditor
//
//  Created by 564008993@qq.com on 05/13/2019.
//  Copyright (c) 2019 564008993@qq.com. All rights reserved.
//

#import "LGViewController.h"
#import "LGImagePickerViewController.h"

@interface LGViewController ()

@end

@implementation LGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LGImagePickerViewController *vc = [[LGImagePickerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

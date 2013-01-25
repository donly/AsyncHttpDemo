//
//  ViewController.h
//  AsyncHttpDemo
//
//  Created by Chan Donly on 13-1-24.
//  Copyright (c) 2013年 Diaoser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate>

@property (retain, nonatomic) IBOutlet UITextField *urlField;
@property (retain, nonatomic) IBOutlet UITextView *responseView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *juhuaView;

@property (nonatomic, retain) NSMutableData *receivedData;

- (IBAction)requestAction:(UIButton *)sender;

@end

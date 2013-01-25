//
//  ViewController.m
//  AsyncHttpDemo
//
//  Created by Chan Donly on 13-1-24.
//  Copyright (c) 2013年 Diaoser. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize urlField;
@synthesize responseView;
@synthesize juhuaView;

- (void)dealloc {
    [urlField release];
    [responseView release];
    [juhuaView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.receivedData = [NSMutableData data];
    [self.juhuaView stopAnimating];
}

- (void)viewDidUnload
{
    [self setUrlField:nil];
    [self setResponseView:nil];
    [self setJuhuaView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Synchronous Request
// Because this call can potentially take several minutes to fail
// (particularly when using a cellular network in iOS),
// you should never call this function from the main thread of a GUI application.
- (void)synchronousRequest {
    // 同步请求
    NSURL *url = [NSURL URLWithString:urlField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    if (error) {
        string = [error localizedDescription];
    }
    
    [self performSelectorOnMainThread:@selector(updateUI:) withObject:string waitUntilDone:NO];
    [self.juhuaView stopAnimating];
}

- (void)asynchronousRequest {
    // 同步请求
    NSURL *url = [NSURL URLWithString:urlField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (IBAction)requestAction:(UIButton *)sender {
    [urlField resignFirstResponder];
    
    if (sender.tag == 1) {  // 同步
        [NSThread detachNewThreadSelector:@selector(synchronousRequest) toTarget:self withObject:nil];
    }
    else if(sender.tag == 2) {  // 异步
        [self asynchronousRequest];
    }
    
    [self.juhuaView setHidden:NO];
    [self.juhuaView startAnimating];
}

- (void)updateUI:(NSString *)string {
    responseView.text = string;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - NSURLConnectionDelegate
// NSURLConnectionDelegate -> NSURLConnectionDataDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    self.receivedData = [NSMutableData data];
    [self.juhuaView stopAnimating];
}

// NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"MIMEType:%@", response.MIMEType);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receivedData appendData:data];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"connection:didReceiveData:%@", str);
    [str release];
    
    NSString *receivedStr = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];
    [self updateUI:receivedStr];
    [receivedStr release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error:%@", [error localizedDescription]);
    
    [self updateUI:[error localizedDescription]];
    self.receivedData = [NSMutableData data];
    [self.juhuaView stopAnimating];
}


@end

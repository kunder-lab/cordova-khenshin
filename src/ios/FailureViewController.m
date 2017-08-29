//
//  FailureViewController.m
//  Browser2AppDemo
//
//  Created by Iván Galaz-Jeria on 1/5/17.
//  Copyright © 2017 khipu. All rights reserved.
//

#import "FailureViewController.h"

@interface FailureViewController ()

@property (strong, nonatomic) void (^finishBlock)(void);
@property (weak, nonatomic) IBOutlet UILabel*   message;
@property (strong, nonatomic) NSString*         messageText;
@end

@implementation FailureViewController

- (void) configureWithPaymentSubject:(NSString*) subject
           formattedAmountAsCurrency:(NSString*) amount
                        merchantName:(NSString*) merchantName
                    merchantImageURL:(NSString*) merchantImageURL
                       paymentMethod:(NSString*) paymentMethod
                               title:(NSString*) title
                             message:(NSString*) message
                              finish:(void (^)(void)) finish {
    
    [self setFinishBlock:finish];
    [self setMessageText:message];
}

- (IBAction)finishClicked:(id)sender {
    
    [self finishBlock]();
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableAttributedString* attrStr = [self.message.attributedText mutableCopy];
    [attrStr.mutableString setString:[self messageText]];
    [self.message setAttributedText:attrStr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

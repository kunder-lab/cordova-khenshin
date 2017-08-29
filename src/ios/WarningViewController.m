//
//  WarningViewController.m
//  Payroll
//
//  Created by Iván Galaz-Jeria on 11/18/16.
//  Copyright © 2016 khipu. All rights reserved.
//

#import "WarningViewController.h"

@interface WarningViewController ()

@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIButton *finish;
@property (strong, nonatomic) NSString* localMessage;
@property (strong, nonatomic) void (^finishBlock)(void);

@end

@implementation WarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[self message] setText:[self localMessage]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureWithPaymentSubject:(NSString*) subject
           formattedAmountAsCurrency:(NSString*) amount
                        merchantName:(NSString*) merchantName
                    merchantImageURL:(NSString*) merchantImageURL
                       paymentMethod:(NSString*) paymentMethod
                               title:(NSString*) title
                             message:(NSString*) message
                              finish:(void (^)(void)) finish {

    [self setLocalMessage:message];
    [self setFinishBlock:finish];
}

- (IBAction)finishClicked:(id)sender {
    
    [self finishBlock]();
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

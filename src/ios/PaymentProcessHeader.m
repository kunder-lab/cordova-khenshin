//
//  PaymentProcessHeader.m
//  Khipu
//
//  Created by Iván Galaz-Jeria on 11/11/16.
//  Copyright © 2016 Khipu. All rights reserved.
//

#import "PaymentProcessHeader.h"
#import "UIImageView+AFNetworking.h"

@interface PaymentProcessHeader()

@end

@implementation PaymentProcessHeader

- (void) configureWithSubject:(NSString*) subject
    formattedAmountAsCurrency:(NSString*) amount
                 merchantName:(NSString*) merchantName
             merchantImageURL:(NSString*) merchantImageURL
                paymentMethod:(NSString *) paymentMethod {
    
    [[self subject] setText:[NSString stringWithFormat:@":%@",subject]];
    [[self amount] setText:[NSString stringWithFormat:@":%@",amount]];
    [[self merchantName] setText:[NSString stringWithFormat:@":%@",merchantName]];
    [[self paymentMethod] setText:[NSString stringWithFormat:@":%@",paymentMethod]];
    [self downloadMerchantImageWithMerchantImageURL:merchantImageURL];
}

- (void)downloadMerchantImageWithMerchantImageURL:(NSString*) pictureURL {
    
    
    NSURLRequest *merchantPictureRequest = [NSURLRequest requestWithURL:[self safeURLWithString:pictureURL]
                                                            cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                        timeoutInterval:90];
    
    [self.merchantImage setImageWithURLRequest:merchantPictureRequest
                              placeholderImage:[UIImage imageNamed:@"Merchant Stand In"]
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

                                           [self.merchantImage setImage:image];
                                       } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {

                                           NSLog(@"failed loading: %@", error);
                                       }
     ];
}

- (NSURL *) safeURLWithString:(NSString *)URLString {
    
    return [NSURL URLWithString:[URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}
@end

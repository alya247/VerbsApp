//
//  RequestToServer.m
//  VerbsApp
//
//  Created by Admin on 22.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "RequestToServer.h"

@implementation RequestToServer

- (void)getContentOnSuccess:(void(^)(NSArray *verbs, NSMutableArray *past)) success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableSet *contentTypes = [[NSMutableSet alloc] initWithSet:manager.responseSerializer.acceptableContentTypes];
    [contentTypes addObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = contentTypes;
    
    [manager GET:@"https://raw.githubusercontent.com/kemitchell/english-irregular-verbs/master/index.json"
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, NSDictionary *responseObject) {
             
             NSArray *a = [responseObject allKeys];
             NSArray *dic = [responseObject allValues];
             NSMutableArray *arrPast = [NSMutableArray new];
             
             for (id x in dic) {
                 [arrPast addObject:[x objectForKey:@"past"]];
             }
             
             if (success)
                 success(a, arrPast);
             
         }failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
}

@end

//
//  RequestToServer.h
//  VerbsApp
//
//  Created by Admin on 22.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface RequestToServer : NSObject

- (void)getContentOnSuccess:(void(^)(NSArray *verbs, NSMutableArray *past)) success
                  onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;

@end

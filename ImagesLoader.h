//
//  ImagesLoader.h
//  VerbsApp
//
//  Created by Admin on 28.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CoreGraphics/CGBase.h>

@interface ImagesLoader : NSObject

@property (strong, nonatomic) NSMutableArray *verbImagesArray;
@property (strong, nonatomic) NSMutableArray *pastImagesArray;

- (void)getVerbArrayImagesOnSuccess:(void(^)(NSArray *arrayOfImages))success
                          onFailure:(void(^)(NSError *error, NSInteger statusCode))failure
                          withVerbs:(NSArray *)verbs
                          andHeight:(CGFloat)h
                           andWidth:(CGFloat)w;


- (void)getPastArrayImagesOnSuccess:(void(^)(NSArray *arrayOfImages))success
                          onFailure:(void(^)(NSError *error, NSInteger statusCode))failure
                          withVerbs:(NSArray *)pastVerbs
                          andHeight:(CGFloat)h
                           andWidth:(CGFloat)w;

@end

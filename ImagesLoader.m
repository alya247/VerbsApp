//
//  ImagesLoader.m
//  VerbsApp
//
//  Created by Admin on 28.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ImagesLoader.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFImageDownloader.h"

@implementation ImagesLoader

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        _verbImagesArray = [NSMutableArray new];
        _pastImagesArray = [NSMutableArray new];
    }
    
    return self;
}

- (void)getVerbArrayImagesOnSuccess:(void(^)(NSArray *arrayOfImages))success
                          onFailure:(void(^)(NSError *error, NSInteger statusCode))failure
                          withVerbs:(NSArray *)verbs
                          andHeight:(CGFloat)h
                           andWidth:(CGFloat)w {

    NSMutableArray *countArray = [NSMutableArray array];
    int count = 0;
    NSNumber *imageCounter = @0;
    
    for (NSString *verb in verbs) {
        
        __block UIImage *image = [UIImage new];
    
        NSString *imageURL = [NSString stringWithFormat:@"http://dummyimage.com/%fx%f/000/fff.png&text=%@", w, h, verb];
        
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
        
        AFImageDownloader *imageDownloader = [AFImageDownloader new];
        
        AFImageDownloadReceipt *imageDowloader = [AFImageDownloadReceipt new];
        
        imageDowloader = [imageDownloader downloadImageForURLRequest:urlRequest
                                               success:^(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject) {
                                                   
                                                   image = responseObject;
                                                   
                                                   [_verbImagesArray addObject:image];
                                                   
                                                   [countArray addObject:imageCounter];
                                                   
                                                   NSMutableArray *dataArray = [NSMutableArray array];
                                                   for (int j =0; j < countArray.count; j++) {
                                                       [dataArray addObject:@{@"imageCounter" : countArray[j],
                                                                              @"img" : _verbImagesArray[j]}];
                                                   }
                                                   
                                                   if ([_verbImagesArray count] == [verbs count]) {
                                                       
                                                       NSArray *sorted = [dataArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"imageCounter" ascending:YES]]];
                                                       
                                                       [_verbImagesArray removeAllObjects];
                                                       
                                                       for (NSDictionary *dict in sorted) {
                                                           [_verbImagesArray addObject:[dict objectForKey:@"img"]];
                                                       }

                                                       if (success)
                                                           success(_verbImagesArray);
                                                   }
                                               }
                                               failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error) {
                                                   
                                                   NSLog(@"Error load image: %@", error);
                                                   
                                               }]; 
        count++;
        imageCounter = @(count+1);
    }
}

- (void)getPastArrayImagesOnSuccess:(void(^)(NSArray *arrayOfImages))success
                          onFailure:(void(^)(NSError *error, NSInteger statusCode))failure
                          withVerbs:(NSArray *)pastVerbs
                          andHeight:(CGFloat)h
                           andWidth:(CGFloat)w {
    

    NSMutableArray *countArray = [NSMutableArray array];
    int count = 0;
    NSNumber *imageCounter = @0;
    
    for (NSString *verb in pastVerbs) {
        
        __block UIImage *image = [UIImage new];
       
        NSString *imageURL = [NSString stringWithFormat:@"http://dummyimage.com/%fx%f/1F78D1/fff.png&text=%@", w, h, verb];
        
        NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
        
        AFImageDownloader *imageDownloader = [AFImageDownloader new];
        
        AFImageDownloadReceipt *imageDowloader = [AFImageDownloadReceipt new];
      
        imageDowloader = [imageDownloader downloadImageForURLRequest:urlRequest
                                                   success:^(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject) {

                                                       image = responseObject;
                                                   
                                                       [_pastImagesArray addObject:image];

                                                       [countArray addObject:imageCounter];

                                                       NSMutableArray *dataArray = [NSMutableArray array];
                                                       for (int j =0; j < countArray.count; j++) {
                                                           [dataArray addObject:@{@"imageCounter" : countArray[j],
                                                                                  @"img" : _pastImagesArray[j]}];
                                                       }

                                                       if ([_pastImagesArray count] == [pastVerbs count]) {

                                                           NSArray *sorted = [dataArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"imageCounter" ascending:YES]]];

                                                           [_pastImagesArray removeAllObjects];
                                                          
                                                           for (NSDictionary *dict in sorted) {
                                                               [_pastImagesArray addObject:[dict objectForKey:@"img"]];
                                                           }
              
                                                           if (success)
                                                               success(_pastImagesArray);
                                                       }
                                                   }
                                                   failure:^(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error) {
                                                   
                                                       NSLog(@"Error load image: %@", error);
                                                   
                                                   }];

        count++;
        imageCounter = @(count+1);
    }
}

@end

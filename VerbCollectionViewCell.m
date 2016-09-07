//
//  VerbCollectionViewCell.m
//  VerbsApp
//
//  Created by Admin on 07.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "VerbCollectionViewCell.h"

@implementation VerbCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _deleteImageView.image = [UIImage imageNamed:@"delete"];
    
    _deleteImageView.hidden = YES;
    _deleteView.hidden = YES;
    
}

- (void)deleteMode:(BOOL) mode {
    
    if (mode == YES) {
        _deleteImageView.hidden = NO;
        _deleteView.hidden = NO;
    }
    else {
        _deleteImageView.hidden = YES;
        _deleteView.hidden = YES;
    }
}

@end

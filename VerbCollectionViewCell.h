//
//  VerbCollectionViewCell.h
//  VerbsApp
//
//  Created by Admin on 07.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerbCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *verbImage;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UIImageView *deleteImageView;

- (void)deleteMode:(BOOL) mode;

@end

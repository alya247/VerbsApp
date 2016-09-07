//
//  ViewController.m
//  VerbsApp
//
//  Created by Admin on 07.08.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController.h"
#import "VerbCollectionViewCell.h"
#import "RequestToServer.h"
#import "UIImageView+AFNetworking.h"
#import "ImagesLoader.h"


@interface ViewController ()

@property (assign, nonatomic) BOOL selectedCellFlag;
@property (assign, nonatomic) BOOL editingModeFlag;

@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSMutableArray *verbsArray;
@property (strong, nonatomic) NSMutableArray *pastArray;

@property (assign, nonatomic) NSInteger rowOfCell;

@property (strong, nonatomic) NSArray *fixedVerbImagesArray;
@property (strong, nonatomic) NSArray *fixedPastImagesArray;

@property (strong, nonatomic) NSMutableArray *verbImagesArray;
@property (strong, nonatomic) NSMutableArray *pastImagesArray;

@property (assign, nonatomic) CGFloat widthOfCell;
@property (assign, nonatomic) CGFloat heightOfCell;

@property (strong, nonatomic) UITapGestureRecognizer *deleteTap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _selectedCellFlag = NO;
    _editingModeFlag = NO;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _verbSearchBar.delegate = self;

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
        _widthOfCell = _collectionView.bounds.size.width / 2 - 5;
        _heightOfCell = 60;
    }
    else {
        _widthOfCell = _collectionView.bounds.size.width / 4 - 15;
        _heightOfCell = 60;
    }
    
    
    RequestToServer *request = [[RequestToServer alloc] init];
    
    ImagesLoader *imagesLoader = [[ImagesLoader alloc] init];
    
    [request getContentOnSuccess:^(NSArray *arr, NSMutableArray *pastVerbs) {
        
        _array = [NSArray arrayWithArray:arr];
        _verbsArray = [NSMutableArray arrayWithArray:_array];
        _pastArray = [NSMutableArray arrayWithArray:pastVerbs];
        
        
        [imagesLoader getVerbArrayImagesOnSuccess:^(NSArray *responseArray) {
            
            _fixedVerbImagesArray = [NSArray arrayWithArray:responseArray];
            _verbImagesArray = [NSMutableArray arrayWithArray:responseArray];
        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                            NSLog(@"Error: %@ StatusCode: %ld", error, (long)statusCode);
                                        }
                                        withVerbs:_verbsArray
                                        andHeight:_heightOfCell
                                         andWidth:_widthOfCell];
        
        
        [imagesLoader getPastArrayImagesOnSuccess:^(NSArray *responseArray) {
            
            _fixedPastImagesArray = [NSArray arrayWithArray:responseArray];
            _pastImagesArray = [NSMutableArray arrayWithArray:responseArray];
        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                            NSLog(@"Error: %@ StatusCode: %ld", error, (long)statusCode);
                                        }
                                        withVerbs:_pastArray
                                        andHeight:_heightOfCell
                                         andWidth:_widthOfCell];
        
        [_collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
        
    }
                       onFailure:^(NSError *error, NSInteger statusCode) {
                           NSLog(@"Error: %@ StatusCode: %ld", error, (long)statusCode);
                       }];
}



#pragma mark - collectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [_verbsArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VerbCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellItem" forIndexPath:indexPath];

    if (_verbImagesArray.count == 0) {
        return cell;
    }
    else {
        
        [UIView transitionWithView:cell.verbImage
                          duration:0.6f
                           options:UIViewAnimationOptionCurveEaseIn
                        animations:^{
                            
                            if (_editingModeFlag == YES) {
                                cell.verbImage.image = _verbImagesArray[indexPath.row];
                                [cell deleteMode:YES];
                                
                                _deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCell:)];
                                _deleteTap.numberOfTapsRequired = 1;
                                
                                cell.deleteImageView.tag = indexPath.row;
                                
                                [cell.deleteImageView addGestureRecognizer:_deleteTap];
                                [cell.deleteImageView setUserInteractionEnabled:YES];
                            }
                            else {
                                cell.verbImage.image = _verbImagesArray[indexPath.row];

                                [cell deleteMode:NO];
                            }
                        }
                        completion:nil];
        return cell;
    }
}

- (void)removeCell:(UITapGestureRecognizer *)tap {
    
    [_verbsArray removeObjectAtIndex:tap.view.tag];
    [_verbImagesArray removeObjectAtIndex:tap.view.tag];
    [_pastImagesArray removeObjectAtIndex:tap.view.tag];
    
    [_collectionView reloadData];
}


#pragma mark collectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VerbCollectionViewCell *cell = (VerbCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (_selectedCellFlag == NO && _editingModeFlag == NO) {
        
        _selectedCellFlag = YES;
    
        NSMutableDictionary *wrapper = [NSMutableDictionary new];
    
        [wrapper setObject:cell forKey:@"cell"];
        [wrapper setObject:indexPath forKey:@"row"];
    
        [UIView transitionWithView:cell.verbImage
                          duration:0.6f
                           options:UIViewAnimationOptionTransitionCurlDown
                        animations:^{
                            
                            [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(changeImage:) userInfo:wrapper repeats:NO];

                            cell.verbImage.image = [_pastImagesArray objectAtIndex:[indexPath row]];
                        }
                        completion:nil];
    }
    else {
        
        _selectedCellFlag = NO;
    }
}

- (void)changeImage:(NSTimer *)timer {
    
    if (_selectedCellFlag == YES) {
    
    NSDictionary *dict = (NSDictionary*)[timer userInfo];
    
    VerbCollectionViewCell *cell = [dict objectForKey:@"cell"];
    
    
    [UIView transitionWithView:cell.verbImage
                      duration:0.6f
                       options:UIViewAnimationOptionTransitionCurlDown
                    animations:^{
                        
                        cell.verbImage.image = [_verbImagesArray objectAtIndex:[[dict objectForKey:@"row"] row]];
                    }
                    completion:nil];
        
        _selectedCellFlag = NO;
    }
}


#pragma mark - collectionViewLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(2, 0, 2, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(_widthOfCell, _heightOfCell);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

    [self.collectionView performBatchUpdates:nil completion:nil];
}


#pragma mark - SearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [_verbSearchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [_verbSearchBar resignFirstResponder];
    [_verbSearchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0) {
        [_verbsArray removeAllObjects];
        [_verbImagesArray removeAllObjects];
        [_pastImagesArray removeAllObjects];
        
        [_verbsArray addObjectsFromArray:_array];
        [_verbImagesArray addObjectsFromArray:_fixedVerbImagesArray];
        [_pastImagesArray addObjectsFromArray:_fixedPastImagesArray];
    }
    else {
        
        [_verbsArray removeAllObjects];
        [_verbImagesArray removeAllObjects];
        [_pastImagesArray removeAllObjects];
        
        for (NSString *s in _array) {
            NSRange r = [s rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (r.location != NSNotFound) {
                [_verbsArray addObject:s];
                
                for (int i = 0; i < _array.count; i++) {
                    
                    if ([s isEqualToString:_array[i]]) {
                        
                        [_verbImagesArray addObject:_fixedVerbImagesArray[i]];
                        [_pastImagesArray addObject:_fixedPastImagesArray[i]];
                    }
                }
            }
        }
    }
    
    [_collectionView reloadData];
}


- (IBAction)editModeButton:(UIBarButtonItem *)sender {
    
    _editingModeFlag = YES;
    
    _doneBarButton.enabled = YES;
    
    _editBarButton.enabled = NO;
    
    
    [_collectionView reloadData];
    
}


#pragma mark - toolBar buttoms

- (IBAction)doneBarButtonAction:(UIBarButtonItem *)sender {
    
    _editingModeFlag = NO;
    
    _doneBarButton.enabled = NO;
    
    _editBarButton.enabled = YES;
    
    [_collectionView reloadData];
}

@end

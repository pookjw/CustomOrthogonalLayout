//
//  HomeViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 4/20/24.
//

#import "HomeViewController.hpp"
#import "CommonCollectionViewController.hpp"
#import "CollectionViewCompositionalLayout.hpp"
#import "OrthogonalCollectionViewLayout.hpp"

__attribute__((objc_direct_members))
@interface HomeViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation HomeViewController
@synthesize cellRegistration = _cellRegistration;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceGrouped];
    
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    if (self = [super initWithCollectionViewLayout:collectionViewLayout]) {
        
    }
    
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cellRegistration];
}

- (UICollectionViewCellRegistration *)cellRegistration {
    if (auto cellRegistration = _cellRegistration) return cellRegistration;
    
    UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id itemIdentifier) {
        UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
        
        NSInteger item = indexPath.item;
        
        if (item == 0) {
            contentConfiguration.text = @"Compositional";
        } else if (item == 1) {
            contentConfiguration.text = @"Orthogonal";
        }
        
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _cellRegistration = [cellRegistration retain];
    return cellRegistration;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:self.cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger item = indexPath.item;
    
    __kindof UICollectionViewLayout *collectionViewLayout;
    if (item == 0) {
        collectionViewLayout = [CollectionViewCompositionalLayout new];
    } else if (item == 1) {
        collectionViewLayout = [OrthogonalCollectionViewLayout new];
    } else {
        abort();
    }
    
    CommonCollectionViewController *viewController = [[CommonCollectionViewController alloc] initWithCollectionViewLayout:collectionViewLayout];
    [collectionViewLayout release];
    
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

@end

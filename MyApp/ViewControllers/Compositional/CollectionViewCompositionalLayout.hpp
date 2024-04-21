//
//  CollectionViewCompositionalLayout.hpp
//  MyApp
//
//  Created by Jinwoo Kim on 4/20/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCompositionalLayout : UICollectionViewCompositionalLayout
+ (instancetype)new;
- (instancetype)init;

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithSection:(NSCollectionLayoutSection*)section NS_UNAVAILABLE;
- (instancetype)initWithSection:(NSCollectionLayoutSection*)section configuration:(UICollectionViewCompositionalLayoutConfiguration*)configuration NS_UNAVAILABLE;
- (instancetype)initWithSectionProvider:(UICollectionViewCompositionalLayoutSectionProvider)sectionProvider NS_UNAVAILABLE;
- (instancetype)initWithSectionProvider:(UICollectionViewCompositionalLayoutSectionProvider)sectionProvider configuration:(UICollectionViewCompositionalLayoutConfiguration*)configuration NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END

//
//  OrthogonalCollectionViewLayout.mm
//  MyApp
//
//  Created by Jinwoo Kim on 4/20/24.
//

#import "OrthogonalCollectionViewLayout.hpp"
#import "NSObject+Foundation_IvarDescription.h"
#import <objc/message.h>
#import <objc/runtime.h>
#include <algorithm>
#include <string.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

/*
 - (BOOL) _hasOrthogonalScrollingSections;
 - (id) _extendedAttributesQueryIncludingOrthogonalScrollingRegions:(struct CGRect)arg1;
 - (struct CGPoint) _offsetForOrthogonalScrollingSection:(long)arg1;
 - (struct CGRect) _orthogonalFrameWithOffsetElidedForItemWithLayoutAttributes:(id)arg1 frame:(struct CGRect)arg2;
 - (unsigned long) _orthogonalScrollingAxis;
 - (struct CGRect) _orthogonalScrollingContentRectForSection:(long)arg1;
 - (double) _orthogonalScrollingDecelerationRateForSection:(long)arg1;
 - (BOOL) _orthogonalScrollingElementShouldAppearAboveForAttributes:(id)arg1;
 - (BOOL) _orthogonalScrollingElementShouldAppearBelowForAttributes:(id)arg1;
 - (struct CGRect) _orthogonalScrollingLayoutRectForSection:(long)arg1;
 - (id) _orthogonalScrollingSections;
 - (void) _setOffset:(struct CGPoint)arg1 forOrthogonalScrollingSection:(long)arg2;
 - (BOOL) _shouldOrthogonalScrollingSectionDecorationScrollWithContentForIndexPath:(id)arg1 elementKind:(id)arg2;
 - (BOOL) _shouldOrthogonalScrollingSectionSupplementaryScrollWithContentForIndexPath:(id)arg1 elementKind:(id)arg2;
 */

@interface OrthogonalCollectionViewLayout ()
@property (class, assign, readonly, nonatomic, direct) void *preferredLayoutAttributesKey;
@property (retain, nonatomic, direct) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *layoutAttributesByIndexPath;
@property (retain, nonatomic, direct) NSMutableDictionary<NSNumber *, id> *sectionDescriptorsBySectionIndex;
@property (nonatomic) CGSize collectionViewContentSize;
@end

@implementation OrthogonalCollectionViewLayout

+ (void *)preferredLayoutAttributesKey {
    static void *key = &key;
    return key;
}

- (instancetype)init {
    if (self = [super init]) {
        _layoutAttributesByIndexPath = [NSMutableDictionary new];
        _sectionDescriptorsBySectionIndex = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)dealloc {
    [_layoutAttributesByIndexPath release];
    [_sectionDescriptorsBySectionIndex release];
    [super dealloc];
}

- (void)prepareLayout {
    [super prepareLayout];
    [self reloadLayoutAttributesByIndexPath];
    
    /*
     -[_UICollectionLayoutSectionDescriptor isEqualToSectionDescriptor:comparingContentOffset:]:
0000000000385c50         sub        sp, sp, #0x30                               ; CODE XREF=-[_UICollectionViewOrthogonalScrollView configureForDescriptor:]+124
0000000000385c54         stp        fp, lr, [sp, #0x20]
0000000000385c58         add        fp, sp, #0x20
0000000000385c5c         cbz        x0, loc_385d54

0000000000385c60         cmp        x1, x0
     
     새로 생성하지 않으면 똑같다고 인지되어서 Orthogonal Layout이 업데이트 되지 않음. 따라서 반드시 Reload를 해야 한다.
     */
    [self reloadSectionDescriptors];
}

- (BOOL)_hasOrthogonalScrollingSections {
    return YES;
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)_extendedAttributesQueryIncludingOrthogonalScrollingRegions:(struct CGRect)arg1 {
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *results = [NSMutableArray array];
    
    unsigned int ivarsCount;
    Ivar *ivars = class_copyIvarList(objc_lookUpClass("_UICollectionLayoutSectionDescriptor"), &ivarsCount);
    
    ptrdiff_t _contentOffset_offset = 0;
    ptrdiff_t _containerLayoutFrame_offset = 0;
    
    for (unsigned int i = 0; i < ivarsCount; i++) {
        Ivar ivar = ivars[i];
        auto name = ivar_getName(ivar);
        
        if (!std::strcmp(name, "_contentOffset")) {
            _contentOffset_offset = ivar_getOffset(ivar);
        } else if (!std::strcmp(name, "_containerLayoutFrame")) {
            _containerLayoutFrame_offset = ivar_getOffset(ivar);
        }
    }
    
    delete ivars;
    
    auto layoutAttributesByIndexPath = self.layoutAttributesByIndexPath;
    
    [self.sectionDescriptorsBySectionIndex enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull sectionIndexNumber, id  _Nonnull sectionDescriptor, BOOL * _Nonnull stop) {
        uintptr_t base = (uintptr_t)(sectionDescriptor);
        CGPoint _contentOffset = *(CGPoint *)(base + _contentOffset_offset);
        CGRect _containerLayoutFrame = *(CGRect *)(base + _containerLayoutFrame_offset);
        
        if (!CGRectIntersectsRect(arg1, _containerLayoutFrame)) return;
        
        CGRect scrollViewBounds = CGRectMake(_contentOffset.x,
                                             _contentOffset.y,
                                             CGRectGetWidth(_containerLayoutFrame),
                                             CGRectGetHeight(_containerLayoutFrame));
        
        NSInteger sectionIndex = sectionIndexNumber.integerValue;
        
        [layoutAttributesByIndexPath enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, UICollectionViewLayoutAttributes * _Nonnull layoutAttributes, BOOL * _Nonnull stop) {
            if (indexPath.section != sectionIndex) return;
            
            if (CGRectIntersectsRect(scrollViewBounds, layoutAttributes.frame)) {
                [results addObject:layoutAttributes];
            }
        }];
    }];
    
    return results;
}

- (NSIndexSet *)_orthogonalScrollingSections {
    return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
}

// 필요 없는듯?
- (struct CGRect)_orthogonalFrameWithOffsetElidedForItemWithLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes frame:(struct CGRect)frame {
    id sectionDescriptor = self.sectionDescriptorsBySectionIndex[@(layoutAttributes.indexPath.section)];
    
    unsigned int ivarsCount;
    Ivar *ivars = class_copyIvarList(objc_lookUpClass("_UICollectionLayoutSectionDescriptor"), &ivarsCount);
    
    auto ivar = std::ranges::find_if(ivars, ivars + ivarsCount, [](Ivar ivar) {
        auto name = ivar_getName(ivar);
        return !std::strcmp(name, "_contentOffset");
    });
    
    uintptr_t base = (uintptr_t)(sectionDescriptor);
    ptrdiff_t offset = ivar_getOffset(*ivar);
    void *location = (void *)(base + offset);
    CGPoint _contentOffset = *(CGPoint *)location;
    
    delete ivars;
    
    CGRect result = CGRectMake(CGRectGetMinX(layoutAttributes.frame) - _contentOffset.x,
                               CGRectGetMinY(layoutAttributes.frame),
                               CGRectGetWidth(layoutAttributes.frame),
                               CGRectGetHeight(layoutAttributes.frame));
    
    return result;
}

- (struct CGPoint)_offsetForOrthogonalScrollingSection:(NSInteger)section {
    id sectionDescriptor = self.sectionDescriptorsBySectionIndex[@(section)];
    
    unsigned int ivarsCount;
    Ivar *ivars = class_copyIvarList(objc_lookUpClass("_UICollectionLayoutSectionDescriptor"), &ivarsCount);
    
    auto ivar = std::ranges::find_if(ivars, ivars + ivarsCount, [](Ivar ivar) {
        auto name = ivar_getName(ivar);
        return !std::strcmp(name, "_contentOffset");
    });
    
    uintptr_t base = (uintptr_t)(sectionDescriptor);
    ptrdiff_t offset = ivar_getOffset(*ivar);
    delete ivars;
    
    void *location = (void *)(base + offset);
    CGPoint _contentOffset = *(CGPoint *)location;
    
    return _contentOffset;
}

- (void)_setOffset:(struct CGPoint)offset forOrthogonalScrollingSection:(NSInteger)section; {
    id sectionDescriptor = self.sectionDescriptorsBySectionIndex[@(section)];
    
    unsigned int ivarsCount;
    Ivar *ivars = class_copyIvarList(objc_lookUpClass("_UICollectionLayoutSectionDescriptor"), &ivarsCount);
    
    auto ivar = std::ranges::find_if(ivars, ivars + ivarsCount, [](Ivar ivar) {
        auto name = ivar_getName(ivar);
        return !std::strcmp(name, "_contentOffset");
    });
    
    uintptr_t base = (uintptr_t)(sectionDescriptor);
    ptrdiff_t _offset = ivar_getOffset(*ivar);
    delete ivars;
    
    CGPoint *location = (CGPoint *)(base + _offset);
    *location = offset;
}

- (id)_sectionDescriptorForSectionIndex:(NSInteger)sectionIndex {
    id result = self.sectionDescriptorsBySectionIndex[@(sectionIndex)];
    return result;
}

- (BOOL) _orthogonalScrollingElementShouldAppearAboveForAttributes:(id)arg1 {
    return NO;
}

- (BOOL) _orthogonalScrollingElementShouldAppearBelowForAttributes:(id)arg1 {
    return NO;
}

//- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *results = [NSMutableArray new];
//    
//    [self.layoutAttributesByIndexPath.allValues enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (CGRectIntersectsRect(obj.frame, rect)) {
//            [results addObject:obj];
//        }
//    }];
//    
//    return [results autorelease];
//}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributesByIndexPath[indexPath];
}

- (void)reloadLayoutAttributesByIndexPath __attribute__((objc_direct)) {
    UICollectionView *collectionView = self.collectionView;
    auto layoutAttributesByIndexPath = self.layoutAttributesByIndexPath;
    
    if (collectionView == nil) {
        [layoutAttributesByIndexPath removeAllObjects];
        return;
    }
    
    NSInteger numberOfSections = collectionView.numberOfSections;
    
    NSIndexSet *sectionIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfSections)];
    
    __block CGFloat totalHeight = 0.f;
    
    [sectionIndexSet enumerateIndexesUsingBlock:^(NSUInteger sectionIndex, BOOL * _Nonnull stop) {
        NSUInteger numberOfItems = [collectionView numberOfItemsInSection:sectionIndex];
        NSIndexSet *itemsIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, numberOfItems)];
        
        if (sectionIndex == 0) {
            __block CGFloat xOffset = 8.f;
            
            [itemsIndexSet enumerateIndexesUsingBlock:^(NSUInteger itemIndex, BOOL * _Nonnull stop) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
                UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                CGFloat width;
                if (UICollectionViewLayoutAttributes *existingLayoutAttributes = layoutAttributesByIndexPath[indexPath]) {
                    width = CGRectGetWidth(existingLayoutAttributes.frame);
                } else {
                    width = 100.f;
                }
                
                layoutAttributes.frame = CGRectMake(xOffset,
                                                    8.f,
                                                    width,
                                                    44.f);
                
                xOffset += width + 8.f;
                layoutAttributesByIndexPath[indexPath] = layoutAttributes;
            }];
            
            totalHeight += 44.f;
        } else if (sectionIndex == 1) {
            CGFloat width = CGRectGetWidth(collectionView.bounds);
            __block CGFloat xOffset = 0.f;
            
            [itemsIndexSet enumerateIndexesUsingBlock:^(NSUInteger itemIndex, BOOL * _Nonnull stop) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:sectionIndex];
                UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                
                layoutAttributes.frame = CGRectMake(xOffset,
                                                    60.f,
                                                    width,
                                                    200.f);
                
                xOffset += width;
                layoutAttributesByIndexPath[indexPath] = layoutAttributes;
            }];
        }
    }];
    
    self.collectionViewContentSize = CGSizeMake(CGRectGetWidth(collectionView.bounds), totalHeight);
}

- (void)reloadSectionDescriptors __attribute__((objc_direct)) {
    auto sectionDescriptorsBySectionIndex = self.sectionDescriptorsBySectionIndex;
    NSUInteger numberOfSectoins = self.collectionView.numberOfSections;
    
    if (numberOfSectoins == 0) {
        [sectionDescriptorsBySectionIndex removeAllObjects];
        return;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
    unsigned int ivarsCount;
    Ivar *ivars = class_copyIvarList(objc_lookUpClass("_UICollectionLayoutSectionDescriptor"), &ivarsCount);
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    auto layoutAttributesByIndexPath = self.layoutAttributesByIndexPath;
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger sectionIndex, BOOL * _Nonnull stop) {
        id _Nullable exsitingDescriptor = sectionDescriptorsBySectionIndex[@(sectionIndex)];
        id sectionDescriptor = [objc_lookUpClass("_UICollectionLayoutSectionDescriptor") new];
        
        std::for_each(ivars, ivars + ivarsCount, [sectionDescriptor, sectionIndex, width, layoutAttributesByIndexPath, exsitingDescriptor](Ivar ivar) {
            const char *ivarName = ivar_getName(ivar);
            uintptr_t base = (uintptr_t)(sectionDescriptor);
            ptrdiff_t offset = ivar_getOffset(ivar);
            void *location = (void *)(base + offset);
            
            if (!std::strcmp(ivarName, "_axis")) {
                *(UIAxis *)location = UIAxisHorizontal;
            } else if (!std::strcmp(ivarName, "_orthogonalScrollingBehavior")) {
                if (sectionIndex == 0) {
                    *(UICollectionLayoutSectionOrthogonalScrollingBehavior *)location = UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous;
                } else if (sectionIndex == 1) {
                    *(UICollectionLayoutSectionOrthogonalScrollingBehavior *)location = UICollectionLayoutSectionOrthogonalScrollingBehaviorPaging;
                }
            } else if (!std::strcmp(ivarName, "_orthogonalScrollingDecelerationRate")) {
                *(UIScrollViewDecelerationRate *)location = UIScrollViewDecelerationRateFast;
            } else if (!std::strcmp(ivarName, "_groupDimension")) {
                *(CGFloat *)location = width;
            } else if (!std::strcmp(ivarName, "_scrollingUnitVector")) {
                if (exsitingDescriptor) {
                    *(CGVector *)location = *(CGVector *)((uintptr_t)exsitingDescriptor + offset);
                }
            } else if (!std::strcmp(ivarName, "_contentOffset")) {
                if (exsitingDescriptor) {
                    *(CGPoint *)location = *(CGPoint *)((uintptr_t)exsitingDescriptor + offset);
                }
            } else if (!std::strcmp(ivarName, "_layoutFrame") || !std::strcmp(ivarName, "_orthogonalScrollViewLayoutFrame") || !std::strcmp(ivarName, "_containerLayoutFrame")) {
                if (sectionIndex == 0) {
                    *(CGRect *)location = CGRectMake(0.f, 0.f, width, 60.f);
                } else if (sectionIndex == 1) {
                    *(CGRect *)location = CGRectMake(0.f, 60.f, width, 200.f);
                }
            } else if (!std::strcmp(ivarName, "_contentFrame")) {
                __block CGFloat maxX = 0.f;
                
                [layoutAttributesByIndexPath enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, UICollectionViewLayoutAttributes * _Nonnull obj, BOOL * _Nonnull stop) {
                    if (key.section == sectionIndex) {
                        maxX = MAX(maxX, CGRectGetMaxX(obj.frame));
                    }
                }];
                
                if (sectionIndex == 0) {
                    *(CGRect *)location = CGRectMake(0.f, 0.f, maxX + 8.f /* padding */, 44.f);
                } else if (sectionIndex == 1) {
                    *(CGRect *)location = CGRectMake(0.f, 60.f, maxX, 200.f);
                }
            } else if (!std::strcmp(ivarName, "_contentInsets")) {
                if (sectionIndex == 0) {
                    *(NSDirectionalEdgeInsets *)location = NSDirectionalEdgeInsetsMake(8.f, 8.f, 8.f, 8.f);
                }
            }
        });
        
        sectionDescriptorsBySectionIndex[@(sectionIndex)] = sectionDescriptor;
        [sectionDescriptor release];
    }];
    
    delete ivars;
}

- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {
    if (preferredAttributes.indexPath.section == 0) {
        return CGRectGetWidth(preferredAttributes.frame) != CGRectGetWidth(originalAttributes.frame);
    } else {
        return NO;
    }
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes {
    UICollectionViewLayoutInvalidationContext *invalidationContext = [UICollectionViewLayoutInvalidationContext new];
    
    [invalidationContext invalidateItemsAtIndexPaths:@[preferredAttributes.indexPath]];
    
    object_setInstanceVariable(invalidationContext, "_orthogonalSectionsWithContentSizeChanges", [[NSMutableIndexSet alloc] initWithIndex:preferredAttributes.indexPath.section]);
    
    objc_setAssociatedObject(invalidationContext, OrthogonalCollectionViewLayout.preferredLayoutAttributesKey, preferredAttributes, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return [invalidationContext autorelease];
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    if (UICollectionViewLayoutAttributes *preferredLayoutAttirubtes = objc_getAssociatedObject(context, OrthogonalCollectionViewLayout.preferredLayoutAttributesKey)) {
        auto layoutAttributesByIndexPath = self.layoutAttributesByIndexPath;
        NSIndexPath *indexPath = preferredLayoutAttirubtes.indexPath;
        UICollectionViewLayoutAttributes *existingLayoutAttributes = layoutAttributesByIndexPath[indexPath];
        
        CGFloat widthDiff = CGRectGetWidth(preferredLayoutAttirubtes.frame) - CGRectGetWidth(existingLayoutAttributes.frame);
        
        existingLayoutAttributes.frame = CGRectMake(CGRectGetMinX(existingLayoutAttributes.frame),
                                                    CGRectGetMinY(existingLayoutAttributes.frame),
                                                    CGRectGetWidth(preferredLayoutAttirubtes.frame),
                                                    CGRectGetHeight(existingLayoutAttributes.frame));
        
        NSInteger preferredItem = indexPath.item;
        NSInteger preferredSection = indexPath.section;
        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:preferredSection];
        
        if (preferredItem + 1 < numberOfItems) {
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(preferredItem + 1, numberOfItems - preferredItem - 1)];
            
            [indexSet enumerateIndexesUsingBlock:^(NSUInteger itemIndex, BOOL * _Nonnull stop) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIndex inSection:preferredSection];
                UICollectionViewLayoutAttributes *layoutAttributes = layoutAttributesByIndexPath[indexPath];
                
                layoutAttributes.frame = CGRectMake(CGRectGetMinX(layoutAttributes.frame) + widthDiff,
                                                    CGRectGetMinY(layoutAttributes.frame),
                                                    CGRectGetWidth(layoutAttributes.frame),
                                                    CGRectGetHeight(layoutAttributes.frame));
            }];
        }
    }
    
    [super invalidateLayoutWithContext:context];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (UICollectionViewLayoutInvalidationContext *)invalidationContextForBoundsChange:(CGRect)newBounds {
    UICollectionViewLayoutInvalidationContext *invalidationContext = [super invalidationContextForBoundsChange:newBounds];
    
    NSUInteger numberOfSections = self.collectionView.numberOfSections;
    
    if (numberOfSections > 0) {
        object_setInstanceVariable(invalidationContext, "_orthogonalSectionsWithContentSizeChanges", [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, numberOfSections)]);
    }
    
    return invalidationContext;
}

@end

//
//  CollectionViewCompositionalLayout.mm
//  MyApp
//
//  Created by Jinwoo Kim on 4/20/24.
//

#import "CollectionViewCompositionalLayout.hpp"
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSObject+Foundation_IvarDescription.h"

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

@implementation CollectionViewCompositionalLayout

- (instancetype)init {
    UICollectionViewCompositionalLayoutConfiguration *configuration = [UICollectionViewCompositionalLayoutConfiguration new];
//    configuration.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self = [super initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment>  _Nonnull layoutEnvironment) {
        if (sectionIndex == 0) {
            NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension estimatedDimension:100.f]
                                                                              heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.f]];
            
            NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
            
            NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension estimatedDimension:100.f]
                                                                               heightDimension:[NSCollectionLayoutDimension absoluteDimension:44.f]];
            
            NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
            
            NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
            section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorContinuous;
            section.interGroupSpacing = 8.f;
            section.contentInsets = NSDirectionalEdgeInsetsMake(8.f, 8.f, 8.f, 8.f);
            
            return section;
        } else if (sectionIndex == 1) {
            NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f]
                                                                              heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.f]];
            
            NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
            
            NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.f]
                                                                               heightDimension:[NSCollectionLayoutDimension absoluteDimension:200.f]];
            
            NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
            
            NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
            section.orthogonalScrollingBehavior = UICollectionLayoutSectionOrthogonalScrollingBehaviorPaging;
            return section;
        } else {
            abort();
        }
    } 
                            configuration:configuration];
    
    [configuration release];
    
    return self;
}

// Called
- (BOOL)_hasOrthogonalScrollingSections {
    objc_super superInfo = { self, [self class] };
    BOOL result = ((BOOL (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, _cmd);
    return result;
}

// Called
- (NSArray<UICollectionViewLayoutAttributes *> *)_extendedAttributesQueryIncludingOrthogonalScrollingRegions:(struct CGRect)arg1 {
    objc_super superInfo = { self, [self class] };
    NSArray<UICollectionViewLayoutAttributes *> * result = ((id (*)(objc_super *, SEL, CGRect))objc_msgSendSuper2)(&superInfo, _cmd, arg1);
    
//    [result enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@", obj.indexPath);
//    }];
    
    return result;
}

// Called
- (struct CGPoint)_offsetForOrthogonalScrollingSection:(long)arg1 {
    objc_super superInfo = { self, [self class] };
    CGPoint result = ((CGPoint (*)(objc_super *, SEL, long))objc_msgSendSuper2)(&superInfo, _cmd, arg1);
//    NSLog(@"%@", NSStringFromCGPoint(result));
    return result;
}

// Called
- (struct CGRect) _orthogonalFrameWithOffsetElidedForItemWithLayoutAttributes:(UICollectionViewLayoutAttributes *)arg1 frame:(struct CGRect)arg2 {
    objc_super superInfo = { self, [self class] };
    CGRect result = ((CGRect (*)(objc_super *, SEL, id, CGRect))objc_msgSendSuper2)(&superInfo, _cmd, arg1, arg2);
//    NSLog(@"(%ld, %ld), %@, %@", arg1.indexPath.section, arg1.indexPath.item, NSStringFromCGRect(arg2), NSStringFromCGRect(result));
    return result;
}

// Not Called
- (unsigned long)_orthogonalScrollingAxis {
    objc_super superInfo = { self, [self class] };
    unsigned long result = ((unsigned long (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, _cmd);
//    NSLog(@"%lu", result);
    return result;
}

// Not Called
- (struct CGRect)_orthogonalScrollingContentRectForSection:(long)arg1 {
    objc_super superInfo = { self, [self class] };
    CGRect result = ((CGRect (*)(objc_super *, SEL, long))objc_msgSendSuper2)(&superInfo, _cmd, arg1);
//    NSLog(@"%@", NSStringFromCGRect(result));
    return result;
}

// Called
- (double)_orthogonalScrollingDecelerationRateForSection:(long)arg1; {
    objc_super superInfo = { self, [self class] };
    double result = ((double (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, _cmd);
//    NSLog(@"%lf", result);
    return result;
}

// Not Called
- (struct CGRect)_orthogonalScrollingLayoutRectForSection:(long)arg1 {
    objc_super superInfo = { self, [self class] };
    CGRect result = ((CGRect (*)(objc_super *, SEL, long))objc_msgSendSuper2)(&superInfo, _cmd, arg1);
//    NSLog(@"%@", NSStringFromCGRect(result));
    return result;
}

// Called
- (id)_orthogonalScrollingSections {
    objc_super superInfo = { self, [self class] };
    id result = ((id (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, _cmd);
//    NSLog(@"%@", result);
    return result;
}

- (BOOL) _orthogonalScrollingElementShouldAppearAboveForAttributes:(id)arg1 {
    objc_super superInfo = { self, [self class] };
    BOOL result = ((BOOL (*)(objc_super *, SEL, id))objc_msgSendSuper2)(&superInfo, _cmd, arg1);
//    NSLog(@"%s: %d", sel_getName(_cmd), result);
    return result;
}
- (BOOL) _orthogonalScrollingElementShouldAppearBelowForAttributes:(id)arg1 {
    objc_super superInfo = { self, [self class] };
    BOOL result = ((BOOL (*)(objc_super *, SEL, id))objc_msgSendSuper2)(&superInfo, _cmd, arg1);
//    NSLog(@"%s: %d", sel_getName(_cmd), result);
    return result;
}

- (id)_sectionDescriptorForSectionIndex:(long)arg1 {
    objc_super superInfo = { self, [self class] };
    id result = ((id (*)(objc_super *, SEL))objc_msgSendSuper2)(&superInfo, _cmd);
    NSLog(@"%@", [result _ivarDescription]);
    return result;
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    NSLog(@"%@", [context _ivarDescription]);
    
    [super invalidateLayoutWithContext:context];
}

@end

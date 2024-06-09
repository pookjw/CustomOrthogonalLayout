//
//  CommonCollectionViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 4/20/24.
//

#import "CommonCollectionViewController.hpp"
#import "CollectionViewCompositionalLayout.hpp"
#import "OrthogonalCollectionViewLayout.hpp"
#import "LabelContentView.hpp"
#import "ColorContentView.hpp"
#import <objc/message.h>
#import <objc/runtime.h>

__attribute__((objc_direct_members))
@interface CommonCollectionViewController ()
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *labelCellRegistration;
@property (retain, readonly, nonatomic) UICollectionViewCellRegistration *colorCellRegistration;
@property (retain, readonly, nonatomic) NSArray<LabelContentConfiguration *> *labelContentConfigurations;
@property (retain, readonly, nonatomic) NSArray<ColorContentConfiguration *> *colorContentConfigurations; 
@end

@implementation CommonCollectionViewController
@synthesize labelCellRegistration = _labelCellRegistration;
@synthesize colorCellRegistration = _colorCellRegistration;
@synthesize labelContentConfigurations = _labelContentConfigurations;
@synthesize colorContentConfigurations = _colorContentConfigurations;

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        UINavigationItem *navigationItem = self.navigationItem;
        
        UIAction *primaryAction = [UIAction actionWithTitle:[NSString string] image:[UIImage systemImageNamed:@"scribble"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            NSArray<UICollectionViewLayoutAttributes *> *extendedAttributesQuery = ((id (*)(id, SEL, CGRect))objc_msgSend)(layout, sel_registerName("_extendedAttributesQueryIncludingOrthogonalScrollingRegions:"), CGRectMake(0.f, 0.f, layout.collectionView.contentSize.width, layout.collectionView.contentSize.height));
            auto layoutAttributes = [layout layoutAttributesForElementsInRect:layout.collectionView.bounds];
            
            id sortedExtendedAttributesQuery = [extendedAttributesQuery sortedArrayUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes * _Nonnull obj1, UICollectionViewLayoutAttributes * _Nonnull obj2) {
                return [obj1.indexPath compare:obj2.indexPath];
            }];
            
            id sortedLayoutAttributes = [layoutAttributes sortedArrayUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes * _Nonnull obj1, UICollectionViewLayoutAttributes * _Nonnull obj2) {
                return [obj1.indexPath compare:obj2.indexPath];
            }];
            
            NSLog(@"%@", sortedExtendedAttributesQuery);
            NSLog(@"%@", sortedLayoutAttributes);
//            NSLog(@"%@",)
            NSLog(@"%@", NSStringFromCGSize(layout.collectionViewContentSize));
        }];
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithPrimaryAction:primaryAction];
        navigationItem.rightBarButtonItem = rightBarButtonItem;
        [rightBarButtonItem release];
    }
    
    return self;
}

- (void)dealloc {
    [_labelCellRegistration release];
    [_colorCellRegistration release];
    [_labelContentConfigurations release];
    [_colorContentConfigurations release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self labelCellRegistration];
    [self colorCellRegistration];
}

- (UICollectionViewCellRegistration *)labelCellRegistration {
    if (auto labelCellRegistration = _labelCellRegistration) return labelCellRegistration;
    
    auto labelContentConfigurations = self.labelContentConfigurations;
    
    UICollectionViewCellRegistration *labelCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewCell.class configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        LabelContentConfiguration *contentConfiguration = labelContentConfigurations[indexPath.item];
        cell.contentConfiguration = contentConfiguration;
    }];
    
    _labelCellRegistration = [labelCellRegistration retain];
    return labelCellRegistration;
}

- (UICollectionViewCellRegistration *)colorCellRegistration {
    if (auto colorCellRegistration = _colorCellRegistration) return colorCellRegistration;
    
    auto colorContentConfigurations = self.colorContentConfigurations;
    
    UICollectionViewCellRegistration *colorCellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewCell.class configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        ColorContentConfiguration *colorcontentConfiguration = colorContentConfigurations[indexPath.item];
        cell.contentConfiguration = colorcontentConfiguration;
    }];
    
    _colorCellRegistration = [colorCellRegistration retain];
    return colorCellRegistration;
}

- (NSArray<LabelContentConfiguration *> *)labelContentConfigurations {
    if (auto labelContentConfigurations = _labelContentConfigurations) return labelContentConfigurations;
    
    NSArray<LabelContentConfiguration *> *labelContentConfigurations = @[
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"1.square.fill"] text:@"One"],
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"2.square.fill"] text:@"Two"],
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"3.square.fill"] text:@"Three"],
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"4.square.fill"] text:@"Four"],
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"5.square.fill"] text:@"Five"],
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"6.square.fill"] text:@"Six"],
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"7.square.fill"] text:@"Seven"],
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"8.square.fill"] text:@"Eight"],
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"9.square.fill"] text:@"Nine"],
        [LabelContentConfiguration configurationWithImage:[UIImage systemImageNamed:@"10.square.fill"] text:@"Ten"]
    ];
    
    _labelContentConfigurations = [labelContentConfigurations retain];
    return labelContentConfigurations;
}

- (NSArray<ColorContentConfiguration *> *)colorContentConfigurations {
    if (auto colorContentConfigurations = _colorContentConfigurations) return colorContentConfigurations;
    
    NSArray<ColorContentConfiguration *> *colorContentConfigurations = @[
        [ColorContentConfiguration configurationWithColor:[UIColor systemRedColor]],
        [ColorContentConfiguration configurationWithColor:[UIColor systemOrangeColor]],
        [ColorContentConfiguration configurationWithColor:[UIColor systemYellowColor]],
        [ColorContentConfiguration configurationWithColor:[UIColor systemGreenColor]],
        [ColorContentConfiguration configurationWithColor:[UIColor systemBlueColor]],
        [ColorContentConfiguration configurationWithColor:[UIColor systemPurpleColor]],
        [ColorContentConfiguration configurationWithColor:[UIColor systemPinkColor]],
        [ColorContentConfiguration configurationWithColor:[UIColor systemCyanColor]],
        [ColorContentConfiguration configurationWithColor:[UIColor systemGrayColor]]
    ];
    
    _colorContentConfigurations = [colorContentConfigurations retain];
    return colorContentConfigurations;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.labelContentConfigurations.count;
    } else if (section == 1) {
        return self.colorContentConfigurations.count;
    } else {
        abort();
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:self.labelCellRegistration forIndexPath:indexPath item:[NSNull null]];
    } else if (section == 1) {
        return [collectionView dequeueConfiguredReusableCellWithRegistration:self.colorCellRegistration forIndexPath:indexPath item:[NSNull null]];
    } else {
        abort();
    }
}

- (void)_collectionView:(UICollectionView *)collectionView orthogonalScrollViewDidScroll:(/* _UICollectionViewOrthogonalScrollView * */__kindof UIScrollView *)scrollView section:(NSInteger)section {
    
}

@end

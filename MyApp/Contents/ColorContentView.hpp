//
//  ColorContentView.hpp
//  MyApp
//
//  Created by Jinwoo Kim on 4/20/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface ColorContentConfiguration : NSObject <UIContentConfiguration>
+ (instancetype)new NS_UNAVAILABLE;
+ (ColorContentConfiguration *)configurationWithColor:(UIColor *)color;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithColor:(UIColor *)color;
@end

@interface ColorContentView : UIView <UIContentView>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithContentConfiguration:(ColorContentConfiguration *)contentConfiguration;
@end

NS_ASSUME_NONNULL_END

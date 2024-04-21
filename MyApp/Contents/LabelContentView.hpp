//
//  LabelContentView.hpp
//  MyApp
//
//  Created by Jinwoo Kim on 4/20/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((objc_direct_members))
@interface LabelContentConfiguration : NSObject <UIContentConfiguration>
+ (instancetype)new NS_UNAVAILABLE;
+ (LabelContentConfiguration *)configurationWithImage:(UIImage *)image text:(NSString *)text;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithImage:(UIImage *)image text:(NSString *)text;
@end

__attribute__((objc_direct_members))
@interface LabelContentView : UIView <UIContentView>
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithContentConfiguration:(LabelContentConfiguration *)contentConfiguration;
@end

NS_ASSUME_NONNULL_END

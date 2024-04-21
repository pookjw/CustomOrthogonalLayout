//
//  SceneDelegate.mm
//  MyApp
//
//  Created by Jinwoo Kim on 4/19/24.
//

#import "SceneDelegate.hpp"
#import "HomeViewController.hpp"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:reinterpret_cast<UIWindowScene *>(scene)];
    
    HomeViewController *homeCollectionViewController = [HomeViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeCollectionViewController];
    [homeCollectionViewController release];
    
    navigationController.navigationBar.prefersLargeTitles = NO;
    
    window.rootViewController = navigationController;
    [navigationController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end

//
//  HRYViewController.m
//  GameControllerSample
//
//  Created by Ryoichi Hara on 2014/05/13.
//  Copyright (c) 2014年 Ryoichi Hara. All rights reserved.
//

#import "HRYViewController.h"
#import "HRYMyScene.h"

@implementation HRYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // Configure the view.
    SKView *skView = (SKView *)self.view;

    if (!skView.scene) {
        // Create and configure the scene.
        HRYMyScene *scene = [HRYMyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;

        [scene configureGameControllers];

        // Present the scene.
        [skView presentScene:scene];
    }

#ifdef DEBUG
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
#endif
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end

//
//  HRYMyScene.m
//  GameControllerSample
//
//  Created by Ryoichi Hara on 2014/05/13.
//  Copyright (c) 2014年 Ryoichi Hara. All rights reserved.
//

#import "HRYMyScene.h"
@import GameController;

@interface HRYMyScene ()

@property (nonatomic, strong) GCController *myController;

@end

@implementation HRYMyScene

#pragma mark - Lifecycle

- (instancetype)initWithSize:(CGSize)size {
    self = [super initWithSize:size];

    if (self) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)update:(CFTimeInterval)currentTime {
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

#pragma mark - Public

- (void)configureGameControllers {
    // Receive notifications when a controller connects or disconnects.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center addObserver:self selector:@selector(gameControllerDidConnect:)
                   name:GCControllerDidConnectNotification object:nil];

    [center addObserver:self selector:@selector(gameControllerDidDisconnect:)
                   name:GCControllerDidDisconnectNotification object:nil];

    // And start looking for any wireless controllers.
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        NSLog(@"Finished finding controllers");
    }];
}

#pragma mark - Private

#pragma mark - Notification

- (void)gameControllerDidConnect:(NSNotification *)notification {
    GCController *controller = notification.object;
    NSLog(@"Connected game controller: %@", controller);

    self.myController = controller;

    // Single-controller game
    if (self.myController.playerIndex == GCControllerPlayerIndexUnset) {
        self.myController.playerIndex = 0;
    }

    GCControllerButtonValueChangedHandler buttonHandler =
    ^(GCControllerButtonInput *button, float value, BOOL pressed) {
        NSLog(@"button value changed: %f", value);
    };

    GCGamepad *profile = self.myController.gamepad;
    profile.buttonA.valueChangedHandler = buttonHandler;
    profile.buttonB.valueChangedHandler = buttonHandler;
    profile.buttonX.valueChangedHandler = buttonHandler;
    profile.buttonY.valueChangedHandler = buttonHandler;
    profile.leftShoulder.valueChangedHandler  = buttonHandler;
    profile.rightShoulder.valueChangedHandler = buttonHandler;

    GCControllerDirectionPadValueChangedHandler padMoveHandler =
    ^(GCControllerDirectionPad *dpad, float xValue, float yValue) {
        NSLog(@"Pad value changed: (%f, %f)", xValue, yValue);
    };

    profile.dpad.valueChangedHandler = padMoveHandler;

    if (self.myController.extendedGamepad) {
        GCExtendedGamepad *extendedProfile = self.myController.extendedGamepad;

        extendedProfile.leftTrigger.valueChangedHandler  = buttonHandler;
        extendedProfile.rightTrigger.valueChangedHandler = buttonHandler;
        extendedProfile.leftThumbstick.valueChangedHandler  = padMoveHandler;
        extendedProfile.rightThumbstick.valueChangedHandler = padMoveHandler;
    }
}

- (void)gameControllerDidDisconnect:(NSNotification *)notification {
    GCController *controller = notification.object;
    self.myController = nil;

    NSLog(@"Disconnected game controller: %@", controller);
}

@end

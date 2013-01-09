//
//  ViewController.h
//  CoreMIDITemplate
//
//  Created by Maxime Bokobza on 8/1/13.
//  Copyright (c) 2013 Maxime Bokobza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMIDI/CoreMIDI.h>

@interface ViewController : UIViewController {
    MIDIClientRef client;
    MIDIPortRef outputPort;
}

@end

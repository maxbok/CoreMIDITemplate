//
//  ViewController.m
//  CoreMIDITemplate
//
//  Created by Maxime Bokobza on 8/1/13.
//  Copyright (c) 2013 Maxime Bokobza. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UILabel *noteLabel;
@property (nonatomic) uint note;

- (IBAction)switchValueChanged:(id)sender;
- (IBAction)buttonPressed;
- (IBAction)buttonReleased;
- (IBAction)sliderValueChanged;

- (void)sendNote:(uint)note on:(BOOL)on;

@end


@implementation ViewController

- (IBAction)switchValueChanged:(id)sender {
    if ([sender isOn]) {
        [[MIDINetworkSession defaultSession] setEnabled:YES];
        
        MIDIClientCreate((CFStringRef)@"CoreMIDITemplate MIDI Client", NULL, NULL, &client);
        MIDIOutputPortCreate(client, (CFStringRef)@"CoreMIDITemplate Output Port", &outputPort);
    } else {
        MIDIClientDispose(client);
        [[MIDINetworkSession defaultSession] setEnabled:NO];
    }
}

- (IBAction)buttonPressed {
    self.note = (uint)self.slider.value;
    [self sendNote:self.note on:YES];
}

- (IBAction)buttonReleased {
    [self sendNote:self.note on:NO];
}

- (void)sendNote:(uint)note on:(BOOL)on {
    // http://www.onicos.com/staff/iz/formats/midi-event.html
    const UInt8 data[]  = { on ? 0x90 : 0x80, note, 127 };
    ByteCount size = sizeof(data);
    
    Byte packetBuffer[sizeof(MIDIPacketList)];
    MIDIPacketList *packetList = (MIDIPacketList *)packetBuffer;
    
    MIDIPacketListAdd(packetList,
                      sizeof(packetBuffer),
                      MIDIPacketListInit(packetList),
                      0,
                      size,
                      data);
    
    for (ItemCount index = 0; index < MIDIGetNumberOfDestinations(); index++) {
        MIDIEndpointRef outputEndpoint = MIDIGetDestination(index);
        if (outputEndpoint)
            MIDISend(outputPort, outputEndpoint, packetList);
    }
}

- (void)sliderValueChanged {
    self.slider.value = round(self.slider.value);
    self.noteLabel.text = [NSString stringWithFormat:@"%.0f", self.slider.value];
}

@end

//
//  DeeplabModel.h
//  Beautify
//
//  Created by Артем Маков on 15.04.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

#include <stdio.h>

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface DeepLabModel : NSObject
- (unsigned char *) process:(CVPixelBufferRef)pixelBuffer additionalColor:(unsigned int)additionalColor;
- (BOOL) loadModel;
@end

//
//  TMDrawer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;
#import "TMProgram.h"
#import "TMTexturedGeometry.h"
#import "TMFrameBuffer.h"
#import "TMTexture.h"
#import "TMProjection.h"

@interface TMDrawer : NSObject

- (instancetype)initWithProgram:(TMProgram *)program
               texturedGeometry:(TMTexturedGeometry *)texturedGeometry
                    frameBuffer:(id<TMFrameBuffer>)frameBuffer texture:(TMTexture *)texture
                     projection:(id<TMProjection>)projection;

- (void)draw;

@end

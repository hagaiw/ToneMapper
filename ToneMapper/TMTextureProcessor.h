//
//  TMTextureProcessor.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMTexture.h"
#import "TMTextureProgram.h"

NS_ASSUME_NONNULL_BEGIN

/// A \c TMTexture processing object.
@interface TMTextureProcessor : NSObject

/// Initialize default properties of the \c TMTextureProcessor.
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/// Initialize with \c TMTextureProgram to be used whenprocessing.
- (instancetype)initWithProgram:(TMTextureProgram *)program;

/// Process the given texture by drawing it onto a \c TMTextureFrameBuffer of the given \c texture's
/// size.
/// A new \c TMTextureFrameBuffer will only be created if the given \c texture does not match the
/// size of the currently held \c TMTextureFrameBuffer.
- (TMTexture *)processTexture:(TMTexture *)texture;

/// Process the given texture and also flip its 'y' axis.
- (TMTexture *)processAndFlipTexture:(TMTexture *)texture;

@end

NS_ASSUME_NONNULL_END

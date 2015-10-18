//
//  TMTextureProcessorFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMTextureProcessor.h"

NS_ASSUME_NONNULL_BEGIN

/// A factory class that produces \c TMTextureProcessor objects.
@interface TMTextureProcessorFactory : NSObject

/// Returns a \c TMTextureProcessor with the given \c TMTexturePRogram.
- (TMTextureProcessor *)processorWithProgram:(TMTextureProgram *)program;

@end

NS_ASSUME_NONNULL_END

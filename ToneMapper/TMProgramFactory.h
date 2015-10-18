//
//  TMProgamFactory.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/13/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMProgram.h"

#import <Foundation/Foundation.h>

#import "TMTextureProgram.h"

NS_ASSUME_NONNULL_BEGIN

/// A factory class used to create new \c TMPrograms.
@interface TMProgramFactory : NSObject

- (TMTextureProgram *)textureDisplayProgram;
- (TMTextureProgram *)textureProcessingProgram;

@end

NS_ASSUME_NONNULL_END
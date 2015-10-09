//
//  TMTexture.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GLKit;

@interface TMTexture : NSObject

@property (readonly, nonatomic) GLuint handle;
@property (readonly, nonatomic) GLenum target;
@property (readonly, nonatomic) GLuint height;
@property (readonly, nonatomic) GLuint width;

- (instancetype)initWithImagePath:(NSString *)imagePath;
- (instancetype)initWithHandle:(GLuint)handle target:(GLenum)target height:(GLuint)height
                         width:(GLuint)width;
- (void)bind;
- (void)destroy;

@end

//
//  TMOpenGLHandler.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMImageProgram.h"
#import "HandleDictionary.h"
#import "TMProgramData.h"

@import GLKit;

@interface TMGLHandler : NSObject

typedef NS_ENUM(NSInteger, ProgramType) {
  ProgramTypeWorkspace,
  ProgramTypeTexture
};

@property (readonly, strong, nonatomic) EAGLContext *context;
@property (readonly, strong, nonatomic) GLKTextureInfo *spriteTexture;
@property (strong, nonatomic) TMImageProgram *textureProgram;
@property (strong, nonatomic) TMImageProgram *workspaceProgram;

- (void)drawInRect:(CGRect)rect;
- (void)saveImage;
- (void)setImageWithName:(NSString *)imageName type:(NSString *)imageType;
- (instancetype)initWithGLKView:(GLKView *)glkView
           workspaceProgramData:(TMProgramData *)workspaceProgramData
             textureProgramData:(TMProgramData *)textureProgramData;

@end

//
//  TMManager.m
//  
//
//  Created by Hagai Weinfeld on 10/13/15.
//
//

#import "TMPipelineManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMPipelineManager ()

/// If true, \c processedTexture does not yet hold the processed \c inputTexture.
/// Calling \c processTexture will set this to false.
@property (nonatomic) BOOL needsProcessing;

/// Holds the resulting processed texture after calling \c processTexture.
@property (strong, nonatomic) TMTexture *processedTexture;

@end

@implementation TMPipelineManager

#pragma mark -
#pragma mark Initializer
#pragma mark -

- (instancetype)init {
  if (self = [super init]) {
    self.needsProcessing = true;
  }
  return self;
}

#pragma mark -
#pragma mark Pipeline
#pragma mark -

- (void)processTexture {
  if (!self.inputTexture) {
    return;
  }
  if (self.needsProcessing) {
    self.processedTexture = [self.processor processAndFlipTexture:self.inputTexture];
    self.needsProcessing = false;
  }
}

- (void)displayProcessedTexture {
  [self.displayer displayTexture:self.processedTexture];
}

#pragma mark -
#pragma mark Properties
#pragma mark -

- (void)setProcessor:(TMTextureProcessor *)processor {
  if (_processor != processor) {
    _processor = processor;
    self.needsProcessing = true;
  }
}

#pragma mark -
#pragma mark IO
#pragma mark -

-(void)saveImage {
  UIImage *image = [self glToUIImage];
  UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

// Taken from: http://www.bit-101.com/blog/?p=1861
-(UIImage *) glToUIImage {
  
  TMTexture *texture = [self.processor processTexture:self.inputTexture];
  NSInteger myDataLength = texture.size.width * texture.size.height * 4;
  
  // allocate array and read pixels into it.
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  glReadPixels(0, 0, texture.size.width, texture.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  
  // make data provider with data.
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
  
  // prep the ingredients
  int bitsPerComponent = 8;
  int bitsPerPixel = 32;
  int bytesPerRow = 4 * texture.size.width;
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  
  // make the cgimage
  CGImageRef imageRef = CGImageCreate(texture.size.width, texture.size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
  
  // then make the uiimage from that
  UIImage *myImage = [UIImage imageWithCGImage:imageRef];
  return myImage;
}

@end

NS_ASSUME_NONNULL_END

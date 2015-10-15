//
//  TMManager.m
//  
//
//  Created by Hagai Weinfeld on 10/13/15.
//
//

#import "TMManager.h"

@interface TMManager ()

@property (nonatomic) BOOL needsProcessing;
@property (strong, nonatomic) TMTexture *processedTexture;

@end

@implementation TMManager

- (instancetype)init {
  if (self = [super init]) {
    self.needsProcessing = true;
  }
  return self;
}

- (void)processTexture {
  if (self.inputTexture) {
    if (self.needsProcessing) {
      self.processedTexture = [self.processor processAndFlipTexture:self.inputTexture];
      self.needsProcessing = false;
    }
    [self.displayer displayTexture:self.processedTexture];
  }
}

- (void)setProcessor:(TMTextureProcessor *)processor {
  if (_processor != processor) {
    _processor = processor;
    self.needsProcessing = true;
  }
}

-(UIImage *) glToUIImage {
  
  self.processedTexture = [self.processor processTexture:self.inputTexture];

  
  NSInteger myDataLength = self.processedTexture.size.width * self.processedTexture.size.height * 4;
  
  // allocate array and read pixels into it.
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  glReadPixels(0, 0, self.processedTexture.size.width, self.processedTexture.size.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  
  // make data provider with data.
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, myDataLength, NULL);
  
  // prep the ingredients
  int bitsPerComponent = 8;
  int bitsPerPixel = 32;
  int bytesPerRow = 4 * self.processedTexture.size.width;
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  
  // make the cgimage
  CGImageRef imageRef = CGImageCreate(self.processedTexture.size.width, self.processedTexture.size.height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
  
  // then make the uiimage from that
  UIImage *myImage = [UIImage imageWithCGImage:imageRef];
  return myImage;
}

-(void)saveImage {
  UIImage *image = [self glToUIImage];
  UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

@end

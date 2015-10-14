//
//  TMManager.m
//  
//
//  Created by Hagai Weinfeld on 10/13/15.
//
//

#import "TMManager.h"

@implementation TMManager

- (void)processTexture {
  TMTexture *texture = [self.processor process];
  [self.displayer displayTexture:texture];
}

- (void)saveImage {

  TMTexture *texture = [self.processor process];
  
  const int w = texture.size.width;
  const int h = texture.size.height;
  const NSInteger myDataLength = w * h * 4;
  
  // allocate array and read pixels into it.
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  glReadPixels(0, 0, w, h, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  // gl renders "upside down" so swap top to bottom into new array.
  // there's gotta be a better way, but this works.
  GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
  for(int y = 0; y < h; y++)
  {
    memcpy( buffer2 + (h - 1 - y) * w * 4, buffer + (y * 4 * w), w * 4 );
  }
  free(buffer); // work with the flipped buffer, so get rid of the original one.
  
  // make data provider with data.
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
  // prep the ingredients
  int bitsPerComponent = 8;
  int bitsPerPixel = 32;
  int bytesPerRow = 4 * w;
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  // make the cgimage
  CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
  // then make the uiimage from that
  UIImage *myImage = [ UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp ];
  UIImageWriteToSavedPhotosAlbum( myImage, nil, nil, nil );
  CGImageRelease( imageRef );
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpaceRef);
  free(buffer2);

}

@end

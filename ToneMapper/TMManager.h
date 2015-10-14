//
//  TMManager.h
//  
//
//  Created by Hagai Weinfeld on 10/13/15.
//
//

#import <Foundation/Foundation.h>
#import "TMTextureProcessor.h"
#import "TMTextureDisplayer.h"

@interface TMManager : NSObject

- (void)processTexture;
- (void)saveImage;

@property (strong, nonatomic) TMTextureProcessor *processor;
@property (strong, nonatomic) TMTextureDisplayer *displayer;
@property (strong, nonatomic) TMTexture *inputTexture;

@end

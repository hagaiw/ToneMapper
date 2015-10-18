//
//  TMManager.h
//  
//
//  Created by Hagai Weinfeld on 10/13/15.
//
//

#import "TMTextureProcessor.h"

#import <Foundation/Foundation.h>

#import "TMTextureDisplayer.h"

NS_ASSUME_NONNULL_BEGIN

/// Manages the flow of proccessing and displaying the \c inputTexture.
/// \c displayer, \c inputTexture and \c processor should all be set before calling methods.
@interface TMPipelineManager : NSObject

/// Runs the \c inputTexture through the processing pipeline and stores the resulting texture in
/// \c processedTexture.
/// Processing will only occur if \c needsProcessing is \c true.
- (void)processTexture;

/// Displays \c processedTexture using \c displayer.
- (void)displayProcessedTexture;

/// Save the processed texture to camera roll.
- (void)saveImage;

/// \c TMTextureDisplayer used to display the texture outputed from the \c processor.
@property (strong, nonatomic) TMTextureDisplayer *displayer;

/// \c TMTexture to be processed and displayed.
@property (strong, nonatomic) TMTexture *inputTexture;

/// \c TMTextureProcessor to process \c inputTexture.
@property (strong, nonatomic) TMTextureProcessor *processor;

@end

NS_ASSUME_NONNULL_END

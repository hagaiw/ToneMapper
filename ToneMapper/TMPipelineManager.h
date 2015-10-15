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
/// \c displayer, \c inputTexture and \c processor should all be set before
@interface TMPipelineManager : NSObject

/// Runs the \c inputTexture through the processing pipeline and displays it.
/// Processing will only occur if \c processor changed since the last call to \c processAndDisplay.
- (void)processAndDisplay;

/// Save the processed texture.
- (void)saveImage;

/// The \c TMTextureDisplayer used to display the texture outputed from the \c processor.
@property (strong, nonatomic) TMTextureDisplayer *displayer;

/// The \c TMTexture to be processed and displayed.
@property (strong, nonatomic) TMTexture *inputTexture;

///
@property (strong, nonatomic) TMTextureProcessor *processor;

@end

NS_ASSUME_NONNULL_END

//
//  TMFrameBuffer.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/11/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@protocol TMFrameBuffer <NSObject>

- (void)bind;

@property (readonly, nonatomic) CGSize size;

@end
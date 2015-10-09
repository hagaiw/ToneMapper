//
//  TMVertices.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@import GLKit;

@protocol TMVertices <NSObject>

@property (readonly, nonatomic) void *vertices;
@property (readonly, nonatomic) GLubyte *indices;
@property (readonly, nonatomic) NSUInteger size;
@property (readonly, nonatomic) GLsizei sizeOfVertice;
@property (readonly, nonatomic) GLsizei sizeOfIndex;

@end

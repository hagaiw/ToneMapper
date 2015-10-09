//
//  TMGeometry.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/9/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TMVertices.h"

@import GLKit;


@interface TMGeometry : NSObject

- (instancetype)initGeometryWithVertices:(id<TMVertices>)vertices;
- (void)bindGeometry;
- (void)linkGeometryToAttribute:(GLuint)attributeHandle size:(GLint)size
                   startPointer:(GLvoid *)startPointer
                         stride:(GLsizei)stride sizeOfVertex:(GLsizei)sizeOfVertex;

@end

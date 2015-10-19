//
//  TMGeometryFactory.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/19/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMGeometryFactory.h"
#import "TMQuadTexturedVertices.h"

@implementation TMGeometryFactory

- (TMTexturedGeometry *)quadGeometry {
  return [[TMTexturedGeometry alloc] initWithTexturedVertices:[TMQuadTexturedVertices new]];
}

@end

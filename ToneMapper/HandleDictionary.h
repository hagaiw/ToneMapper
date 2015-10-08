//
//  handleDictionary.h
//  ToneMapper
//
//  Created by Hagai Weinfeld on 10/8/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GLKit;

@interface HandleDictionary : NSObject

- (void)setHandle:(GLuint)handle forKey:(NSString *)key;
- (GLuint)handleForKey:(NSString *)key;

@end

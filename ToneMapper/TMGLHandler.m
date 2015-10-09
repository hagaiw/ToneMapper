//
//  TMOpenGLHandler.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "TMGLHandler.h"


@interface TMGLHandler ()

@property (readwrite, strong, nonatomic) EAGLContext *context;

@property (nonatomic) CGRect viewFrame;

@property (nonatomic) GLuint projectionUniform;
@property (nonatomic) GLuint textureUniform;
@property (nonatomic) GLuint resolutionUniform;
@property (nonatomic) GLuint textureFrameBufferTextureHandle;

@property (nonatomic) GLfloat counter; // TODO delete

@property (nonatomic) GLuint textureFrameBufferID;
@property (nonatomic) GLint screenFrameBufferID;

@property (strong, nonatomic) GLKView *glkView;

@property (readwrite, strong, nonatomic) GLKTextureInfo *spriteTexture;

@end

@implementation TMGLHandler

typedef struct {
  float Position[3];
  float TexCoord[2];
} Vertex;

static const Vertex Vertices[] = {
  {{1, -1, 0}, {1, 0}},
  {{1, 1, 0}, {1, 1}},
  {{-1, 1, 0}, {0, 1}},
  {{-1, -1, 0}, {0, 0}}
};

static const GLubyte Indices[] = {
  0, 1, 2,
  2, 3, 0
};

- (instancetype)initWithGLKView:(GLKView *)glkView
           workspaceProgramData:(TMProgramData *)workspaceProgramData
             textureProgramData:(TMProgramData *)textureProgramData {
  if (self = [super init]) {
//    [self initContext];
//    glkView.context = self.context;
    self.glkView = glkView;
    self.workspaceProgram = [self programWithProgramData:workspaceProgramData];
    self.textureProgram = [self programWithProgramData:textureProgramData];
    [self setupGL];
  }
  return self;

}

- (void)setViewFrame:(CGRect)viewFrame {
  _viewFrame = viewFrame;
}

- (void)initContext {
  
}

- (void)setupGL {
  [self setAttributesForPorgram:self.textureProgram];
  [self setAttributesForPorgram:self.workspaceProgram];
  [self initVBOs];
}

- (void)setAttributesForPorgram:(TMImageProgram *)program {
//  glEnableVertexAttribArray([program.handlesForAttributes handleForKey:@"Position"]);
//  glEnableVertexAttribArray([program.handlesForAttributes handleForKey:@"TexCoordIn"]);
//  glVertexAttribPointer([program.handlesForAttributes handleForKey:@"TexCoordIn"], 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
//  glVertexAttribPointer([program.handlesForAttributes handleForKey:@"TexCoordIn"], 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
//  NSLog(@"%lul", sizeof(Vertex));
}

- (void)initVBOs {
  
  GLuint vertexBuffer;
  GLuint indexBuffer;
  
  glGenBuffers(1, &vertexBuffer);
  glGenBuffers(1, &indexBuffer);
  
  glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
  
  glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
  
  NSLog(@"%lu", sizeof(Vertices));
  NSLog(@"%lu", sizeof(Indices));
  
//  glVertexAttribPointer([self.textureProgram.handlesForAttributes handleForKey:@"Position"], 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
//  glVertexAttribPointer([self.textureProgram.handlesForAttributes handleForKey:@"TexCoordIn"], 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
}

- (void)drawInRect:(CGRect)rect {
  // Draw to Texture
//  glUseProgram(self.textureProgram.program);
//  glBindFramebuffer(GL_FRAMEBUFFER, self.textureFrameBufferID);
//  //glBindTexture(GL_TEXTURE_2D, self.spriteTexture.name);
  glUniform1i(_textureUniform, 0);
  glUniformMatrix4fv(_projectionUniform, 1, 0, GLKMatrix4Identity.m);
//  glViewport(0, 0, self.spriteTexture.width, self.spriteTexture.height);
//  glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);

  //Draw to Workspace
//  glUseProgram(self.workspaceProgram.program);
//  [self.glkView bindDrawable];
//  glBindTexture(GL_TEXTURE_2D, self.textureFrameBufferTextureHandle);
//  glUniform1i(_textureUniform, 0);
//  glUniformMatrix4fv(_projectionUniform, 1, 0, [self ratioFixMatrixForTextureInfo:self.spriteTexture
//                                                                      displaySize:rect.size].m);
//  glClearColor(self.counter, 0.5, 0.0, 1.0);
//  glClear(GL_COLOR_BUFFER_BIT);
//  glViewport(0, 0, rect.size.width*2, rect.size.height*2);
//  glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
}

- (GLKMatrix4)ratioFixMatrixForTextureInfo:(GLKTextureInfo *)textureInfo
                               displaySize:(CGSize)displaySize {
  GLfloat displayRatio = displaySize.height / displaySize.width;
  GLfloat imageRatio = textureInfo.height / textureInfo.width;
  GLfloat fitRatio = 1.0;
  if (displayRatio > imageRatio) {
    fitRatio = displaySize.width / textureInfo.width;
  } else {
    fitRatio = displaySize.height / textureInfo.height;
  }
  GLfloat xRatio = fitRatio * textureInfo.width / displaySize.width;
  GLfloat yRatio = fitRatio * textureInfo.height / displaySize.height;
  return GLKMatrix4Scale(GLKMatrix4Identity, xRatio, yRatio, 1.0);
}

- (void)setImageWithName:(NSString *)imageName type:(NSString *)imageType{
  
  glActiveTexture(GL_TEXTURE0);
  NSError *textureLoaderError;
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:imageType];
  
    // Delete Existing Buffer
  GLuint currentTextureName = self.spriteTexture.name;
  glDeleteTextures(1, &currentTextureName);
  glDeleteBuffers(1, &_textureFrameBufferID);
  
  // Load original texture
  NSLog(@"GL Error = %u", glGetError()); // Fixes an issue where GLKTextureLoader returns nil
  self.spriteTexture = [GLKTextureLoader textureWithContentsOfFile:imagePath options:nil error:&textureLoaderError];
  

  
  // Create a new frame buffer:
  glGenFramebuffers(1, &_textureFrameBufferID);
  glBindFramebuffer(GL_FRAMEBUFFER, self.textureFrameBufferID);
  glGenTextures(1, &_textureFrameBufferTextureHandle);
  glBindTexture(GL_TEXTURE_2D, self.textureFrameBufferTextureHandle);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  self.spriteTexture.width, self.spriteTexture.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, self.textureFrameBufferTextureHandle, 0);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  NSLog(@"GL Error = %u", glGetError());
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  NSLog(@"GL Error = %u", glGetError());
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  NSLog(@"GL Error = %u", glGetError());
  
  GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
  if(status != GL_FRAMEBUFFER_COMPLETE) {
    NSLog(@"failed to make complete framebuffer object %x", status);
  }
  
  [self setupGL];
  [self.glkView bindDrawable];
  [self.glkView display];
}

- (void)saveImage {
  
  GLuint width = self.viewFrame.size.width;
  GLuint height = self.viewFrame.size.height;
  
  //create new offscreen frame buffer:
  
  // create and bind:
  GLuint framebuffer;
  glGenFramebuffers(1, &framebuffer);
  glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
  
//  GLuint depthRenderbuffer;
//  glGenRenderbuffers(1, &depthRenderbuffer);
//  glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
//  glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
//  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
  
  GLuint colorRenderbuffer;
  glGenRenderbuffers(1, &colorRenderbuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
  glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA4, width, height);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
  
  GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER) ;
  if(status != GL_FRAMEBUFFER_COMPLETE) {
    NSLog(@"failed to make complete framebuffer object %x", status);
  }
  
  glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
  
  
  // Draw
  glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
  
  
//  GLubyte* pixels = (GLubyte*) malloc(width * height * sizeof(GLubyte) * 4);
//  glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
//  
//  
  
  ////////
  int s = 1;
  
  const int w = width/2;
  const int h = height/2;
  const NSInteger myDataLength = w * h * 4 * s * s;
  // allocate array and read pixels into it.
  GLubyte *buffer = (GLubyte *) malloc(myDataLength);
  glReadPixels(0, 0, w*s, h*s, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
  // gl renders "upside down" so swap top to bottom into new array.
  // there's gotta be a better way, but this works.
  GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
  for(int y = 0; y < h*s; y++)
  {
    memcpy( buffer2 + (h*s - 1 - y) * w * 4 * s, buffer + (y * 4 * w * s), w * 4 * s );
  }
  free(buffer); // work with the flipped buffer, so get rid of the original one.
  
  // make data provider with data.
  CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);
  // prep the ingredients
  int bitsPerComponent = 8;
  int bitsPerPixel = 32;
  int bytesPerRow = 4 * w * s;
  CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
  CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
  CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
  // make the cgimage
  CGImageRef imageRef = CGImageCreate(w*s, h*s, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
  // then make the uiimage from that
  UIImage *myImage = [ UIImage imageWithCGImage:imageRef scale:s orientation:UIImageOrientationUp ];
  UIImageWriteToSavedPhotosAlbum( myImage, nil, nil, nil );
  CGImageRelease( imageRef );
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpaceRef);
  free(buffer2);
}

- (TMImageProgram *)programWithProgramData:(TMProgramData *)programData {
  
  GLuint program = glCreateProgram();
  
  GLuint vertexShaderHandle = [self compileShader:programData.vertexShaderName withType:GL_VERTEX_SHADER];
  GLuint fragmentShaderHandle = [self compileShader:programData.fragmentShaderName withType:GL_FRAGMENT_SHADER];
  
  glAttachShader(program, vertexShaderHandle);
  glAttachShader(program, fragmentShaderHandle);
  
  glLinkProgram(program);
  // Check linkage success.
  GLint linkSuccess;
  glGetProgramiv(program, GL_LINK_STATUS, &linkSuccess);
  if (linkSuccess == GL_FALSE) {
    GLchar messages[256];
    glGetProgramInfoLog(program, sizeof(messages), 0, &messages[0]);
    NSString *messageString = [NSString stringWithUTF8String:messages];
    NSLog(@"%@", messageString);
    exit(1);
  }
  
  HandleDictionary *handlesForAttributes = [[HandleDictionary alloc] init];
  for (NSString *attribute in programData.attributes) {
    GLuint handle = glGetAttribLocation(program, [attribute UTF8String]);
    [handlesForAttributes setHandle:handle forKey:attribute];
  }
  
  HandleDictionary *handlesForUniforms = [[HandleDictionary alloc] init];
  for (NSString *uniform in programData.uniforms) {
    GLuint handle = glGetUniformLocation(program, [uniform UTF8String]);
    [handlesForUniforms setHandle:handle forKey:uniform];
  }
  
  return [[TMImageProgram alloc] initWithProgramHandle:program
                                  handlesForAttributes:handlesForAttributes
                                    handlesForUniforms:handlesForUniforms];
  
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
  
  // 1
  NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                         ofType:@"glsl"];
  NSError* error;
  NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                     encoding:NSUTF8StringEncoding error:&error];
  if (!shaderString) {
    NSLog(@"Error loading shader: %@", error.localizedDescription);
    exit(1);
  }
  
  // 2
  GLuint shaderHandle = glCreateShader(shaderType);
  
  // 3
  const char * shaderStringUTF8 = [shaderString UTF8String];
  int shaderStringLength = (int)[shaderString length];
  glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
  
  // 4
  glCompileShader(shaderHandle);
  
  // 5
  GLint compileSuccess;
  glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
  if (compileSuccess == GL_FALSE) {
    GLchar messages[256];
    glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
    NSString *messageString = [NSString stringWithUTF8String:messages];
    NSLog(@"%@", messageString);
    exit(1);
  }
  
  return shaderHandle;
}

@end


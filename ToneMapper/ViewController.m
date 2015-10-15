//
//  ViewController.m
//  ToneMapper
//
//  Created by Hagai Weinfeld on 9/30/15.
//  Copyright (c) 2015 Lightricks Ltd. All rights reserved.
//

#import "ViewController.h"
#import "TMViewController.h"

@interface ViewController ()

@property (strong, nonatomic) TMViewController *openGLVC;
@property (weak, nonatomic) IBOutlet UIView *glview;

@end

@implementation ViewController

- (IBAction)switchImage:(UIButton *)sender {
//  [self.openGLVC switchImage];
  [self startMediaBrowser];
}

- (IBAction)saveImage:(UIButton *)sender {
  [self.openGLVC saveImage];
}

- (IBAction)moveImage:(UIPanGestureRecognizer *)sender {
  GLfloat dx = [sender translationInView:self.openGLVC.view].x / self.openGLVC.view.frame.size.width;
  GLfloat dy = [sender translationInView:self.openGLVC.view].y / self.openGLVC.view.frame.size.height;
  [self.openGLVC moveImageByX: dx*[UIScreen mainScreen].scale y: -dy*[UIScreen mainScreen].scale
                movementEnded:([sender state] == UIGestureRecognizerStateEnded)];
}

- (IBAction)zoomImage:(UIPinchGestureRecognizer *)sender {
  CGPoint point = [sender locationInView:self.openGLVC.view];
  CGFloat pinchX = 2*(point.x - (self.openGLVC.view.frame.size.width / 2) ) / self.openGLVC.view.frame.size.width;
  CGFloat pinchY = 2*(point.y - (self.openGLVC.view.frame.size.height / 2) ) / self.openGLVC.view.frame.size.height;
  [self.openGLVC zoomImageByScale:[sender scale] positionX:pinchX positionY:pinchY
                        zoomEnded:([sender state] == UIGestureRecognizerStateEnded)];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.openGLVC = [[TMViewController alloc] init];
  [self addChildViewController:self.openGLVC];
  self.openGLVC.view.frame = self.glview.frame;
  [self.glview addSubview:self.openGLVC.view];
  [self.openGLVC didMoveToParentViewController:self];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) makeUIImagePickerController {
  
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
  
  [UIImagePickerController availableMediaTypesForSourceType:
   UIImagePickerControllerSourceTypeSavedPhotosAlbum];
  
  [picker setMediaTypes:[UIImagePickerController availableMediaTypesForSourceType:
                         UIImagePickerControllerSourceTypeSavedPhotosAlbum]];
}

- (BOOL) startMediaBrowser {

  UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
  mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  mediaUI.allowsEditing = NO;
  mediaUI.delegate = self;
  [self presentViewController:mediaUI animated:YES completion:nil];
  return YES;
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
  [self dismissViewControllerAnimated:YES completion:nil];
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  
  
  
  
  [self.openGLVC switchImage:[self prepareImage:image]];
}

- (UIImage *)prepareImage:(UIImage *)image {
  
  int max;
  glGetIntegerv(GL_MAX_TEXTURE_SIZE, &max);
  NSUInteger maxResolution = max;
  GLfloat imageScale = 1.0;
  
  
  
  NSUInteger maxDimension = image.size.height > image.size.width ? image.size.height : image.size.width;
  
  if (maxDimension > maxResolution) {
    imageScale = (GLfloat)maxResolution / maxDimension;
  }
  
  
  
  UIGraphicsBeginImageContextWithOptions(image.size, NO, imageScale);
  [image drawInRect:(CGRect){0, 0, image.size}];
  UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return normalizedImage;
}

@end

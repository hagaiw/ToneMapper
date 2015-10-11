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
  [self.openGLVC switchImage];
}

- (IBAction)saveImage:(UIButton *)sender {
  [self.openGLVC saveImage];
}

- (IBAction)moveImage:(UIPanGestureRecognizer *)sender {
  GLfloat dx = [sender translationInView:self.view].x / self.view.frame.size.width;
  GLfloat dy = [sender translationInView:self.view].y / self.view.frame.size.height;
  [self.openGLVC moveImageByX: dx*2 y: -dy*2
                movementEnded:([sender state] == UIGestureRecognizerStateEnded)];
}

- (IBAction)zoomImage:(UIPinchGestureRecognizer *)sender {
 [self.openGLVC zoomImageToScale:[sender scale]
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

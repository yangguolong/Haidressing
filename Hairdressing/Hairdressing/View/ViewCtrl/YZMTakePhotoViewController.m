//
//  YZMTakePhotoViewController.m
//  Hairdressing
//
//  Created by Yangjiaolong on 16/3/31.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "YZMTakePhotoViewController.h"
#import "AVCaptureManager.h"
#import "AVCamPreviewView.h"
#import "YZMTakePhotoViewModel.h"
#import "YZMTakePhotoAlertView.h"


@interface YZMTakePhotoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *adjustLocationImageView;

@property (weak, nonatomic) IBOutlet UIImageView *displayImageView;
@property (nonatomic,strong)AVCaptureManager * avcManager;
@property (weak, nonatomic) IBOutlet AVCamPreviewView *previewView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

@property (weak, nonatomic) IBOutlet UIButton *photoButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic,strong,readonly) YZMTakePhotoViewModel * viewModel;


@end

@implementation YZMTakePhotoViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    self.avcManager  = [[AVCaptureManager alloc]initWithPreviewView:_previewView];
    
//    [self.avcManager start];
    
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        DLog(@"service %@",self.viewModel.services);
        [self.viewModel.services dismissViewModelAnimated:YES completion:nil];
        
    }];
   self.cameraButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        
       
            [self.avcManager stillImageWithBlock:^(UIImage *image) {
                
                self.viewModel.captureImage = image;
                
//                self.displayImageView.image = image;
//                self.displayImageView.hidden = NO;
//                self.adjustLocationImageView.hidden = YES;
                
                [self starAnimationForCapture];
                
                [self.avcManager stop];
                
   
            }];
   
    
       return [RACSignal empty];
    }];
    
    self.photoButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       @strongify(self)
        UIImagePickerController * pickerViewCtrl = [[UIImagePickerController alloc]init];
        pickerViewCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerViewCtrl.delegate = self;
        [self presentViewController:pickerViewCtrl animated:YES completion:nil];
        return [RACSignal empty];
    }];

    // Do any additional setup after loading the view.
}


- (IBAction)changeCameraPositionButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    DevicePosition  posotion = sender.selected ? DevicePositionback : DevicePositionFront;
    [self.avcManager changeDevicePosition:posotion];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.avcManager start];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [YZMTakePhotoAlertView showWithType:YZMTakePhotoAlertForTake];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)starAnimationForCapture{
    self.displayImageView.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        self.displayImageView.alpha = 1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    
    DLog(@"didpickerImage %@",image);
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self.viewModel.didPickerImageCommand execute:image];
    }];
    
    
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
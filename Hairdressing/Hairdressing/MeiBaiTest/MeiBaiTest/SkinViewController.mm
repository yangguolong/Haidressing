//
//  SkinViewController.m
//  HairTest
//
//  Created by cloudream on 16/4/29.
//  Copyright © 2016年 cloudream. All rights reserved.
//

#import "SkinViewController.h"

#include "ImageProcessor.h"
#include <string.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface SkinViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *oldImageView;

@property (weak, nonatomic) IBOutlet UIImageView *theNewImageView;


@property (nonatomic,assign)int imageW;

@property (nonatomic,assign)int imageH;
@end

@implementation SkinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    UIImage * image = _oldImageView.image;

    unsigned char * cpath ;//= (unsigned char *) [self getImageData:image];
    CGImageRef imageRef = _oldImageView.image.CGImage;
//    CGBitmapContextGetData
    _imageW = image.size.width;
    _imageH = image.size.height;
    
    cpath =  [self getPixelColorAtLocation:CGPointMake(0, 0) andImageRef:imageRef];
    
     NSString *docs = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"/temp.jpg"];
    
    NSLog(@"docs %@",docs);

    NSLog(@"old  image size %@",NSStringFromCGSize(image.size));
    
    
  unsigned char * f =   [self fourToThire:cpath];
//    return;
    unsigned char * t = (unsigned char *)malloc(_imageW * _imageH * 3 * sizeof(unsigned char));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1 ~150 美白
//        SkinWhiteningUseColorBalance(cpath, cpath, (int)image.size.width, (int)image.size.height, (int)(image.size.width * 3),100);
        //快速美白

//        SkinWhiteningFast(f, t, (int)image.size.width, (int)image.size.height+100, (int)(image.size.width * 3));
        
        DermabrasionFilter(f, t, (int)image.size.width, (int)image.size.height, (int)(image.size.width * 3),15);
//        sleep(4);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
            CGImageRef inputCGImage = [image CGImage];
            NSUInteger width =                 CGImageGetWidth(inputCGImage);
            NSUInteger height = CGImageGetHeight(inputCGImage);
            
            // 2.
            NSUInteger bytesPerPixel = 4;
            NSUInteger bytesPerRow = bytesPerPixel *     width;
            NSUInteger bitsPerComponent = 8;
            CGContextRef context =     CGBitmapContextCreate([self thireTofour:t], width, height, bitsPerComponent, bytesPerRow, colorSpace,kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
            CGImageRef newimageref = CGBitmapContextCreateImage(context);
            
//            CGContextDrawImage(context, CGRectMake(0,     0, width, height), newimageref);
            UIImage * aImage = [UIImage imageWithCGImage:newimageref];
            _theNewImageView.image = aImage;
            // 5. Cleanup
            CGColorSpaceRelease(colorSpace);
            CGContextRelease(context); 

        });
    });

    // Do any additional setup after loading the view.
}
-(unsigned char *)fourToThire:(unsigned char *)four{
    
    unsigned char * thire = (unsigned char *)malloc(_imageW * _imageH * 3 * sizeof(unsigned char));
    for (int k = 0; k< _imageW *_imageH * 4; k++) {
//        printf("%x",four[k]);

    }
    for (int i = 0; i < _imageH; i++) {
        for (int j = 0; j< _imageW ; j+=4) {
 
            thire[j*i+j+0] = four[j*i+j+1];
            thire[j*i+j+1] = four[j*i+j+2];
            thire[j*i+j+2] = four[j*i+j+3];

        }
//        printf("\n");
    }
//            printf("\n");

    for (int k = 0; k< _imageW *_imageH * 3; k++) {
//        printf("%x",thire[k]);

    }
    return thire;
}
-(unsigned char *)thireTofour:(unsigned char *)thire{
    unsigned char * four = (unsigned char *)malloc(_imageW * _imageH * 4* sizeof(unsigned char));
    int index = 0;
//    four[0] = 0xff;
    for (int i = 0; i < _imageH; i++) {
        for (int j = 0; j< _imageW; j+=3) {

            
            four[++index] = 0xff;
            four[++index] = thire[j*i+j+0];
            four[++index] = thire[j*i+j+1];
            four[++index] = thire[j*i+j+2];
//            printf(" new  %d %d %d %d  old %d %d %d \n",four[index-3],four[index-2],four[index-1],four[index],thire[j*i+j+0],thire[j*i+j+1],thire[j*i+j+2]);
            
        }
//        printf("\n");
    }
    return four;

}


-(unsigned char *)getPixelWithImageRef:(CGImageRef) ref{
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:ref];
    if (cgctx == NULL) {
        return nil;
    }
    size_t w = CGImageGetWidth(ref);
    size_t h = CGImageGetHeight(ref);
    CGRect rect = {{0,0},{(CGFloat)w,(CGFloat)h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, ref);
    
    
    // context.
    unsigned char* data = (unsigned char *)CGBitmapContextGetData (cgctx);
    
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return data;
    
}
- (unsigned char *) getPixelColorAtLocation:(CGPoint)point andImageRef:(CGImageRef )ref {
    UIColor* color = nil;
    CGImageRef inImage = ref;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }
    point.x = _imageW/2;
    point.y = _imageH/2;
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{(CGFloat)w,(CGFloat)h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = (unsigned char *)CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            NSLog(@"offset: %d", offset);
            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }
        
    }
    /**
    for (int i = 0; i< h; i++) {
        for (int j = 0; j< w; j++) {
            if (data != NULL) {
                //offset locates the pixel in the data from x,y.
                //4 for 4 bytes of data per pixel, w is width of one row of data.
                @try {
                    int offset = 4*((w*round(i))+round(j));
                    NSLog(@"offset: %d", offset);
                    int alpha =  data[offset];
                    int red = data[offset+1];
                    int green = data[offset+2];
                    int blue = data[offset+3];
                    NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
                    color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
                }
                @catch (NSException * e) {
                    NSLog(@"%@",[e reason]);
                }
                @finally {
                }
                
            }
 
        }
    }
    */
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return data;
}
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color spacen");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    UIImagePickerController * p = [[UIImagePickerController alloc]init];
//    p.delegate = self;
//    p.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [self presentViewController:p animated:YES completion:^{
//        
//    }];
//    

}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"info %@",info);
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init]; // 1
    [library assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) { // 2
        
        NSDictionary *imageInfo = [asset defaultRepresentation].metadata;
        NSLog(@" image %@",imageInfo);
    } failureBlock:^(NSError *error) {
        
        
    }];

}

 unsigned char* MakeStringCopy (const char* string)
{
    if (string == NULL)
        return NULL;
    
    char* res = ( char*)malloc(strlen(string) + 1);
    strcpy(res, string);
    return (unsigned char *)res;
}

- (void*)getImageData:(UIImage*)image
{
    void* imageData;
    if (imageData == NULL)
        imageData = malloc(4 * image.size.width * image.size.height);
    
    CGColorSpaceRef cref = CGColorSpaceCreateDeviceRGB();
    CGContextRef gc = CGBitmapContextCreate(imageData,
                                            image.size.width,image.size.height,
                                            8,image.size.width*4,
                                            cref,kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(cref);
    UIGraphicsPushContext(gc);
    
//    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    
    UIGraphicsPopContext();
    CGContextRelease(gc);
    
    return imageData;
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

//
//  LYBThreadViewController.m
//  OCStudyDemo
//
//  Created by Albin on 2018/4/13.
//  Copyright © 2018年 Albin. All rights reserved.
//

#define dispatch_main_async_safe(block)\
if([NSThread isMainThread]){\
block();\
}else{\
dispatch_async(dispatch_get_main_queue(),block);\
}\


#import "LYBThreadViewController.h"

@interface LYBThreadViewController ()<NSURLSessionDelegate,NSURLSessionDataDelegate>

@property (nonatomic ,strong) UIImageView *imageView;
@property (assign, nonatomic) NSInteger expectedSize;

@end

@implementation LYBThreadViewController{
    size_t width, height;
    UIImageOrientation orientation;
    BOOL responseFromCached;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIImageView *imgView = [[UIImageView alloc]init];
//    [self.view addSubview:imgView];
//    imgView.center = self.view.center;
//    imgView.backgroundColor = [UIColor redColor];
//    _imageView = imgView;
//
//    dispatch_queue_t queue = dispatch_queue_create("Albin", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        NSLog(@"isMain-->%d",[NSThread isMainThread]);
//
//        NSString *imageStr = @"http://www.egouz.com/uploadfile/2015/0305/20150305103626911.jpg";
//        NSURL *imageUrl = [NSURL URLWithString:imageStr];
//        NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
//        UIImage *image = [UIImage imageWithData:imageData];
//
//        dispatch_main_async_safe(^{
//            NSLog(@"isMain-->%d",[NSThread isMainThread]);
//            imgView.image = image;
//            CGPoint center = imgView.center;
//            [imgView sizeToFit];
//            imgView.center = center;
//        });
//    });
    
    
    
//    [self download];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 200)];
    view1.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view1];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 50, 200)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    view.layer.anchorPoint = CGPointMake(0.5, 1);
    view.layer.affineTransform = CGAffineTransformMakeRotation(M_PI/4);
    view.center = CGPointMake(view.center.x, view.center.y+view.frame.size.height/2);
    
}

- (void)download{
    NSURL *url = [NSURL URLWithString:@"http://www.egouz.com/uploadfile/2015/0305/20150305103626911.jpg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 15;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler{
    NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
    self.expectedSize = expected;

    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    NSMutableData *imageData = [[NSMutableData alloc]init];
    [imageData appendData:data];
    const NSInteger totalSize = imageData.length;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (width + height == 0) {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (properties) {
            NSInteger orientationValue = -1;
            CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
            if (val) CFNumberGetValue(val, kCFNumberLongType, &height);
            val = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
            if (val) CFNumberGetValue(val, kCFNumberLongType, &width);
            val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
            if (val) CFNumberGetValue(val, kCFNumberNSIntegerType, &orientationValue);
            CFRelease(properties);
            
            // When we draw to Core Graphics, we lose orientation information,
            // which means the image below born of initWithCGIImage will be
            // oriented incorrectly sometimes. (Unlike the image born of initWithData
            // in didCompleteWithError.) So save it here and pass it on later.
            orientation = [[self class] orientationFromPropertyValue:(orientationValue == -1 ? 1 : orientationValue)];
        }
        
    }
    
    if (width + height > 0 && totalSize <= self.expectedSize) {
        // Create the image
        CGImageRef partialImageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        
#ifdef TARGET_OS_IPHONE
        // Workaround for iOS anamorphic image
        if (partialImageRef) {
            const size_t partialHeight = CGImageGetHeight(partialImageRef);
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
            CGColorSpaceRelease(colorSpace);
            if (bmContext) {
                CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = partialHeight}, partialImageRef);
                CGImageRelease(partialImageRef);
                partialImageRef = CGBitmapContextCreateImage(bmContext);
                CGContextRelease(bmContext);
            }
            else {
                CGImageRelease(partialImageRef);
                partialImageRef = nil;
            }
        }
#endif
        
        if (partialImageRef) {
            UIImage *image = [UIImage imageWithCGImage:partialImageRef scale:1 orientation:orientation];
            dispatch_main_async_safe(^{
                _imageView.image = image;
                CGPoint center = _imageView.center;
                _imageView.center = center;
                [_imageView sizeToFit];
            });
            
            CGImageRelease(partialImageRef);
           
        }
    }
    
    CFRelease(imageSource);
    
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler{
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
}


#pragma mark Helper methods

+ (UIImageOrientation)orientationFromPropertyValue:(NSInteger)value {
    switch (value) {
        case 1:
            return UIImageOrientationUp;
        case 3:
            return UIImageOrientationDown;
        case 8:
            return UIImageOrientationLeft;
        case 6:
            return UIImageOrientationRight;
        case 2:
            return UIImageOrientationUpMirrored;
        case 4:
            return UIImageOrientationDownMirrored;
        case 5:
            return UIImageOrientationLeftMirrored;
        case 7:
            return UIImageOrientationRightMirrored;
        default:
            return UIImageOrientationUp;
    }
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

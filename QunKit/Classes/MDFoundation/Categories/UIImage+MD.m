//
//  UIImage+MD.m
//  shop
//
//  Created by 陈芳 on 2021/12/14.
//

#import "UIImage+MD.h"
#import <Accelerate/Accelerate.h>
#import "MDFoundation.h"
@implementation UIImage (MD)


+ (UIImage *)dl_imageNamed:(NSString *)named inBundle:(id)bundle  {
    if (!bundle) {
        return [UIImage imageNamed:named];
    }
    
    NSBundle *targetBundle = nil;
    if ([bundle isKindOfClass:NSBundle.class]) {
        targetBundle = bundle;
        
    } else if ([bundle isKindOfClass:NSString.class]) {
        targetBundle = Bundle(bundle);
    }
    
    UIImage *image = [UIImage imageNamed:named inBundle:targetBundle compatibleWithTraitCollection:nil];
    if (!image) {
        image = [UIImage imageNamed:named];
    }
    
    return image;
}

+ (UIImage *)dl_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)dl_imageWithSize:(CGSize)size {
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat defaultFormat];
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
    UIImage *newImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    }];

    return newImage;
}

- (UIImage *)dl_imageWithMaxWidth:(CGFloat)maxWidth {
    if (self.size.width <= maxWidth) return self;
    CGFloat height = (maxWidth / self.size.width * self.size.height);
    return [self dl_imageWithSize:CGSizeMake(maxWidth, height)];
}

- (UIImage *)dl_imageWithMaxDimension:(CGFloat)maxDimension {
    if (maxDimension <= 0) {
        return self;
    }
    
    if (self.size.width <= maxDimension && self.size.height <= maxDimension) {
        return self;
    }
    
    CGFloat ratio = maxDimension / MAX(self.size.width, self.size.height);
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    UIGraphicsImageRendererFormat *format = [UIGraphicsImageRendererFormat defaultFormat];
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:newSize format:format];
    UIImage *newImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    }];

    return newImage;
}

- (UIImage *)dl_blurWithValue:(CGFloat)blurValue {
    @try {
        NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
        UIImage* destImage = [UIImage imageWithData:imageData];
        
        if (blurValue < 0.f || blurValue > 1.f) {
            blurValue = 0.5f;
        }
        int boxSize = (int)(blurValue * 40);
        boxSize = boxSize - (boxSize % 2) + 1;
        
        CGImageRef img = destImage.CGImage;
        
        vImage_Buffer inBuffer, outBuffer;
        
        vImage_Error error;
        
        void *pixelBuffer;
        
        
        CGDataProviderRef inProvider = CGImageGetDataProvider(img);
        CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
        
        
        inBuffer.width = CGImageGetWidth(img);
        inBuffer.height = CGImageGetHeight(img);
        inBuffer.rowBytes = CGImageGetBytesPerRow(img);
        
        inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
        
        //create vImage_Buffer for output
        
        pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
        
        if(pixelBuffer == NULL)
            NSLog(@"No pixelbuffer");
        
        outBuffer.data = pixelBuffer;
        outBuffer.width = CGImageGetWidth(img);
        outBuffer.height = CGImageGetHeight(img);
        outBuffer.rowBytes = CGImageGetBytesPerRow(img);
        
        // Create a third buffer for intermediate processing
        void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
        vImage_Buffer outBuffer2;
        outBuffer2.data = pixelBuffer2;
        outBuffer2.width = CGImageGetWidth(img);
        outBuffer2.height = CGImageGetHeight(img);
        outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
        
        //perform convolution
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        if (error) {
            NSLog(@"error from convolution %ld", error);
        }
        error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        if (error) {
            NSLog(@"error from convolution %ld", error);
        }
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        if (error) {
            NSLog(@"error from convolution %ld", error);
        }
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                                 outBuffer.width,
                                                 outBuffer.height,
                                                 8,
                                                 outBuffer.rowBytes,
                                                 colorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
        CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
        UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
        
        //clean up
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);
        
        free(pixelBuffer);
        free(pixelBuffer2);
        CFRelease(inBitmapData);
        
        CGImageRelease(imageRef);
        
        return returnImage;
        
    } @catch (NSException *exception) {
        return self;
    }
}

+ (UIImage *)scaleImage:(NSInteger)kb{
    
    if (!self) {
        return self;
    }
    if (kb<1) {
        return self;
    }
    kb*=1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(self, compression);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(self, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

@end

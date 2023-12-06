//
//  ViewController.m
//  AssetsLook
//
//  Created by yanguo sun on 2023/6/20.
//

#import "ViewController.h"
#import "SDImageCache.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *allBundles =  [self allBundle];

    for (NSBundle *aBundle in allBundles) {
        NSURL *url = [aBundle.bundleURL URLByAppendingPathComponent:@"Assets.carInfo.json"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:url.path]) {
            continue;
        }
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSArray *assets = [self parseJsonFromData:data];
        NSMutableArray *imageAssets = [NSMutableArray array];
        for (NSDictionary *item in assets) {
            if([[item objectForKey:@"AssetType"] isEqualToString:@"Image"]) {
                [imageAssets addObject:item];
            }
            if([[item objectForKey:@"AssetType"] isEqualToString:@"PackedImage"]) {
                [imageAssets addObject:item];
            }
            for (NSDictionary *item in imageAssets) {
                NSString *name = [item objectForKey:@"Name"];
                NSString *RenditionName = [item objectForKey:@"RenditionName"];
                @autoreleasepool {
                    UIImage *image = [UIImage imageNamed:name inBundle:aBundle compatibleWithTraitCollection:nil];
                    NSString *kk = [NSString stringWithFormat:@"%@_%@", aBundle.bundleURL.lastPathComponent, RenditionName];
                    [SDImageCache.sharedImageCache storeImage:image forKey:kk toDisk:YES];
                }
            }
        }

    }
}

- (NSArray<NSBundle *> *)allBundle {
    NSMutableArray *ret = [NSMutableArray arrayWithObject:[NSBundle mainBundle]];

    // 获取主 bundle 的路径
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];

    // 创建 NSFileManager 对象
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // 获取主 bundle 目录下所有文件和目录的列表
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:mainBundlePath error:nil];

    // 遍历所有文件和目录
    for (NSString *item in contents) {
        // 判断是否为 bundle 目录
        if ([item.pathExtension isEqualToString:@"bundle"]) {
            // 构建 bundle 的完整路径
            NSString *bundlePath = [mainBundlePath stringByAppendingPathComponent:item];

            // 创建 NSBundle 对象
            NSBundle *subBundle = [NSBundle bundleWithPath:bundlePath];
            [ret addObject:subBundle];
        }
    }
    return ret;
}

- (id)parseJsonFromData:(NSData *)data {
    NSParameterAssert(data);
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:NULL];
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}
@end

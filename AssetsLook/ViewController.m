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
    NSURL *url = [NSBundle.mainBundle URLForResource:@"Assets.carInfo" withExtension:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *assets = [self parseJsonFromData:data];

    NSMutableArray *imageAssets = [NSMutableArray array];
    for (NSDictionary *item in assets) {
        if([[item objectForKey:@"AssetType"] isEqualToString:@"Image"]) {
            [imageAssets addObject:item];
        }
    }

    for (NSDictionary *item in imageAssets) {
        NSString *name = [item objectForKey:@"Name"];
        NSString *RenditionName = [item objectForKey:@"RenditionName"];


        UIImage *image = [UIImage imageNamed:name];
        [SDImageCache.sharedImageCache storeImage:image forKey:RenditionName toDisk:YES];
    }

    // Do any additional setup after loading the view.
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

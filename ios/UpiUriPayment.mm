#import "UpiUriPayment.h"

#import <React/RCTLog.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 
@interface RCTUpiPaymentModuleController : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *appIcons; // To hold app icons
- (instancetype)initWithItems:(NSArray *)items url:(NSString *)url;
@end
@implementation UpiUriPayment {
  NSArray *upiApps;
  NSMutableArray *installedAppList;
}

RCT_EXPORT_MODULE()

- (instancetype)init {
  self = [super init];
  if (self) {
    upiApps = @[];
    installedAppList = [NSMutableArray array];
  }
  return self;
}
 
// To export a module named RCTCalendarModule
 
RCT_EXPORT_METHOD(openUPIApp:(NSString *)url)
{
  [self checkUPIInstalledAppsInDevice];
  dispatch_async(dispatch_get_main_queue(), ^{
      UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
      RCTUpiPaymentModuleController *bottomSheetVC = [[RCTUpiPaymentModuleController alloc] initWithItems:installedAppList url:url];
      [rootViewController presentViewController:bottomSheetVC animated:YES completion:nil];
    });
}
 
- (void)checkUPIInstalledAppsInDevice {
  [installedAppList removeAllObjects]; // Clear the list to avoid duplicates
  NSDictionary *resourceFileDictionary = nil;
  NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
  if (path) {
    resourceFileDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
  }
  if (resourceFileDictionary) {
    upiApps = [resourceFileDictionary objectForKey:@"LSApplicationQueriesSchemes"];
  }
  UIApplication *app = [UIApplication sharedApplication];
  for (NSString *installedApp in upiApps) {
    NSString *appScheme = [NSString stringWithFormat:@"%@://app", installedApp];
    if ([app canOpenURL:[NSURL URLWithString:appScheme]]) {
      if (![installedAppList containsObject:installedApp]) {
        [installedAppList addObject:installedApp];
      }
    }
  }
}
@end

@implementation RCTUpiPaymentModuleController
 
- (instancetype)initWithItems:(NSArray *)items url:(NSString *)url {
  self = [super init];
  if (self) {
    _items = items;
    _url = url;
    _appIcons = [NSMutableDictionary dictionary];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat padding = 10.0;
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 4 * padding) / 3;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth * 0.75); // Square items
    layout.minimumInteritemSpacing = padding;
    layout.minimumLineSpacing = padding;
    layout.sectionInset = UIEdgeInsetsMake(padding, padding, padding, padding);
 
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
  }
  return self;
}
 
- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIView *contentView = [[UIView alloc] init];
  contentView.backgroundColor = [UIColor whiteColor];
  contentView.layer.cornerRadius = 20;
  contentView.translatesAutoresizingMaskIntoConstraints = NO;
  
  UILabel *headingLabel = [[UILabel alloc] init];
  headingLabel.text = @"Open with";
  headingLabel.font = [UIFont boldSystemFontOfSize:20];
  headingLabel.textAlignment = NSTextAlignmentCenter;
  headingLabel.translatesAutoresizingMaskIntoConstraints = NO;
  
  [contentView addSubview:headingLabel];
  [contentView addSubview:self.collectionView];
 
  [self.view addSubview:contentView];
 
  [NSLayoutConstraint activateConstraints:@[
    [contentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    [contentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
    [contentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
    [contentView.heightAnchor constraintEqualToConstant:400],
    [headingLabel.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:16],
    [headingLabel.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:10],
    [headingLabel.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-10],
    [headingLabel.heightAnchor constraintEqualToConstant:30],
    [self.collectionView.topAnchor constraintEqualToAnchor:headingLabel.bottomAnchor constant:10],
    [self.collectionView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor],
    [self.collectionView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
    [self.collectionView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
  ]];
}
 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.items.count;
}
 
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
  // Clear old content
  for (UIView *view in cell.contentView.subviews) {
    [view removeFromSuperview];
  }
  NSString *appName = [self.items objectAtIndex:indexPath.row];
  // Set the app icon if available
  UIImage *appIcon = [self.appIcons objectForKey:appName];
  CGFloat iconSize = cell.contentView.bounds.size.width / 2; // Make the icon smaller
  CGFloat padding = 5.0;
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((cell.contentView.bounds.size.width - iconSize) / 2, padding, iconSize, iconSize)];
  imageView.layer.cornerRadius = 12.0;
  imageView.layer.borderWidth = 1.0;
  imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
  imageView.clipsToBounds = YES;
  if (appIcon) {
    imageView.image = appIcon;
  } else {
    // Fetch the app icon
    [self getAppIconURL:appName completion:^(NSURL *iconURL) {
      if (iconURL) {
        NSData *imageData = [NSData dataWithContentsOfURL:iconURL];
        UIImage *image = [UIImage imageWithData:imageData];
        if (image) {
          dispatch_async(dispatch_get_main_queue(), ^{
            [self.appIcons setObject:image forKey:appName];
            UICollectionViewCell *updateCell = [collectionView cellForItemAtIndexPath:indexPath];
            UIImageView *updateImageView = [[UIImageView alloc] initWithImage:image];
            updateImageView.frame = CGRectMake((updateCell.contentView.bounds.size.width - iconSize) / 2, padding, iconSize, iconSize);
            updateImageView.layer.cornerRadius = 12.0;
            updateImageView.layer.borderWidth = 1.0;
            updateImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
            updateImageView.clipsToBounds = YES;
            [updateCell.contentView addSubview:updateImageView];
          });
        }
      }
    }];
  }
  [cell.contentView addSubview:imageView];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, iconSize + 2 * padding, cell.contentView.bounds.size.width, 20)];
  label.text = [appName capitalizedString];
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont boldSystemFontOfSize:12];
  label.textColor = [UIColor blackColor];
  [cell.contentView addSubview:label];
 
  return cell;
}
 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSString *selectedApp = [self.items objectAtIndex:indexPath.row];
  NSString *formattedUrl = [self.url stringByReplacingOccurrencesOfString:@"upi://pay" withString:@"upi//pay"];
  NSString *appUrl = [NSString stringWithFormat:@"%@://%@", selectedApp, formattedUrl];
  NSURL *url = [NSURL URLWithString:appUrl];
  if ([[UIApplication sharedApplication] canOpenURL:url]) {
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
  }
}
 
- (void)getAppIconURL:(NSString *)appName completion:(void (^)(NSURL *iconURL))completion {
  NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&entity=software&country=IN", appName];
  NSURL *url = [NSURL URLWithString:urlString];
 
  [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error || !data) {
      completion(nil);
      return;
    }
 
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *results = json[@"results"];
    if (results.count > 0) {
      NSString *iconURLString = results[0][@"artworkUrl100"];
      NSURL *iconURL = [NSURL URLWithString:iconURLString];
      completion(iconURL);
    } else {
      completion(nil);
    }
  }] resume];
}
@end

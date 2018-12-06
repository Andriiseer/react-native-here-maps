#import "React/RCTEventDispatcher.h"
#import <NMAKit/NMAMapScheme.h>
#import "React/RCTView.h"
@import NMAKit;

@class RCTEventDispatcher;

@interface HRMapView : UIView <NMANavigationManagerDelegate>

@property (nonatomic, strong) IBOutlet NMAMapView* mapView;
@property (nonatomic) NMACoreRouter* router;
@property (nonatomic) NMAMapRoute* mapRoute;
@property (nonatomic, strong) NSDictionary *InitCoords;

@property (nonatomic, strong) NSDictionary *routeParams;

- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher NS_DESIGNATED_INITIALIZER;
@property (nonatomic) NMARoute* route1;



@end

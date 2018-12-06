#import <Foundation/Foundation.h>
#import "React/RCTBridge.h"
#import <MapKit/MapKit.h>
@import NMAKit;
#import <React/RCTViewManager.h>
#import "HRMapView.h"

@interface HRMapManager : RCTViewManager
@end

@implementation HRMapManager

RCT_EXPORT_MODULE()

/*
- (instancetype)init {
  self = [super init];
  [NMAApplicationContext setAppId:@"TEST"
                          appCode:@"TEST"];
  return self;
}*/

HRMapView * myScript;




RCT_EXPORT_METHOD(Action:(NSString *)name)
{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:self];
}


@synthesize bridge = _bridge;

- (UIView *)view
{
  return [[HRMapView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
    
  //return [[NMAMapView alloc] initWithFrame:self.view.frame];
  //[self.view addSubview:_map];
  
  /*
   NMAGeoCoordinates* coord = [[NMAGeoCoordinates alloc]
   initWithLatitude:49.0
   longitude:123.0];
   [mapView setGeoCenter:coord
   zoomLevel:NMAMapViewPreserveValue
   withAnimation:NMAMapAnimationNone];
   */
  
  //return _map;
  
  //return [[MKMapView alloc] init];
}

- (NSArray *) customDirectEventTypes {
    return @[
             @"onCreateRoute",
             @"onNavStart"
             ];
}


- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_EXPORT_VIEW_PROPERTY(InitCoords, NSDictionary);
RCT_EXPORT_VIEW_PROPERTY(routeParams, NSDictionary);

@end

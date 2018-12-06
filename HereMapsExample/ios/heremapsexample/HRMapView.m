#import <Foundation/Foundation.h>
@import NMAKit;

#import "React/RCTBridgeModule.h"
#import "React/RCTEventDispatcher.h"
#import "React/UIView+React.h"
#import "React/RCTLog.h"
#import "HRMapView.h"

@implementation HRMapView : UIView  {
  
  RCTEventDispatcher *_eventDispatcher;
  
  NMACoreRouter* router;
  NMAMapRoute* mapRoute;
  NMARoute* route;
  NMAMapMarker *loadMarker;
  NMAMapMarker *unLoadMarker;
  NMANavigationManager* navigationManager;
  NMAGeoBoundingBox* geoBoundingBox;
  NSInteger _eventCounter;
  NSInteger Gtopleft;
    
}



- (void)setRouteParams:(NSDictionary *)routeParams {
    if (![routeParams isEqual:_routeParams]) {
        _routeParams = [routeParams copy];
    }
    if (![[routeParams objectForKey:@"OriginLat"] isEqual: 0]) {
        [self CreateRoute];
    }
}

- (void)setInitCoords:(NSDictionary *)InitCoords
{
    if (![InitCoords isEqual:_InitCoords]) {
        _InitCoords = [InitCoords copy];
        NMAGeoCoordinates* coord = [[NMAGeoCoordinates alloc]
                                    initWithLatitude: [[_InitCoords objectForKey:(@"Lat")] doubleValue]
                                    longitude:[[_InitCoords objectForKey:(@"Lng")] doubleValue]];
        [_mapView setGeoCenter:coord
                     zoomLevel:NMAMapViewPreserveValue
                 withAnimation:NMAMapAnimationNone];
         }
}



- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher
{
  if ((self = [super init])) {
      
      
      
    _eventDispatcher = eventDispatcher;
    _mapView = [[NMAMapView alloc] init];
    navigationManager = NMANavigationManager.sharedNavigationManager;
    navigationManager.delegate = self;
    [navigationManager setVoicePackageMeasurementSystem:NMAMeasurementSystemImperialUS];
      [navigationManager setAccessibilityLanguage:(@"ru-RU")];
     

      NMAGeoCoordinates* coord = [[NMAGeoCoordinates alloc]
                                  initWithLatitude: [[_InitCoords objectForKey:(@"Lat")] doubleValue]
                                  longitude:[[_InitCoords objectForKey:(@"Lng")] doubleValue]];
      
      NMAZoomRange * myZoomRange = [[NMAZoomRange alloc] initWithMinZoomLevel:(0.00f) maxZoomLevel:(100.0f)];
    NMACustomizableScheme * customScheme;
      customScheme = [_mapView  createCustomizableSchemeWithName:@"myCustomScheme" basedOnScheme: NMAMapSchemeNormalNightWithTraffic];
      NMACustomizableColor *roadcat1 = [customScheme colorForProperty:NMASchemeStreetCategory3Color forZoomLevel:0.0f];
      [roadcat1 setRed:174];
      [roadcat1 setGreen:220];
      [roadcat1 setBlue:240];
      NMACustomizableColor *roadcat0 = [customScheme colorForProperty:NMASchemeStreetCategory0Color forZoomLevel:0.0f];
      [roadcat0 setRed:25.0f];
      [roadcat0 setGreen:86.0f];
      [roadcat0 setBlue:117.0f];
      NMACustomizableColor *roadcat0cen = [customScheme colorForProperty:NMASchemeStreetCategory0Color forZoomLevel:0.0f];
      [roadcat0cen setRed:25.0f];
      [roadcat0cen setGreen:86.0f];
      [roadcat0cen setBlue:117.0f];
      NMACustomizableColor *roadcat0th = [customScheme colorForProperty:NMASchemeStreetCategory2Color forZoomLevel:0.0f];
      [roadcat0th setRed:69.0f];
      [roadcat0th setGreen:121];
      [roadcat0th setBlue:183];
      NMACustomizableColor *roadcat3 = [customScheme colorForProperty:NMASchemeStreetCategory1Color forZoomLevel:0.0f];
      [roadcat3 setRed:45.0f];
      [roadcat3 setGreen:186.0f];
      [roadcat3 setBlue:186.0f];
      NMACustomizableColor *roadcat2 = [customScheme colorForProperty:NMASchemeStreetCategory0StreetPolylineAttributeTollColor forZoomLevel:0.0f];
      [roadcat2 setRed:69.0f];
      [roadcat2 setGreen:121.0f];
      [roadcat2 setBlue:163.0f];



    [customScheme setColorProperty:roadcat0 forZoomRange: myZoomRange];
    [customScheme setColorProperty:roadcat0th forZoomRange: myZoomRange];
    [customScheme setColorProperty:roadcat0cen forZoomRange: myZoomRange];
    [customScheme setColorProperty:roadcat1 forZoomRange: myZoomRange];
    [customScheme setColorProperty:roadcat2 forZoomRange: myZoomRange];
    [customScheme setColorProperty:roadcat3 forZoomRange: myZoomRange];
      [ _mapView setMapScheme: @"myCustomScheme"];
      
    [_mapView setGeoCenter:coord
                zoomLevel:NMAMapViewPreserveValue
            withAnimation:NMAMapAnimationNone];
    
    _mapView.zoomLevel = 10;
    
     // [self createRoute];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                               selector:@selector(RouteSelector)
//                                                   name:@"CreateRoute"
//                                                 object:nil];
      
    [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(NavSelector)
                                                   name:@"Navigate"
                                                 object:nil];
      
    [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(navStop)
                                                   name:@"navStop"
                                                 object:nil];
      
      
      // Set this controller to be the delegate of NavigationManager, so that it can listening to the
      // navigation events through the different protocols.In this example, we will
      // implement 2 protocol methods for demo purpose, please refer to HERE iOS SDK API documentation
      // for details
      

      
      
  }
  
  return self;
}


-(void) navStop
{
    [self stopNavigation];
}

-(void) NavSelector
{
    [self startNavigation];
    
}



#pragma mark - React View Management

- (void)insertReactSubview:(UIView *)view atIndex:(NSInteger)atIndex
{
  //RCTLogError(@"image cannot have any subviews");
  return;
}

- (void)removeReactSubview:(UIView *)subview
{
  //RCTLogError(@"image cannot have any subviews");
  return;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _mapView.frame = self.bounds;
  [self addSubview:_mapView];
}


- (void)CreateRoute
{
    router = nil;
    self.route1 = nil;
    [self->_mapView removeMapObject:(self->mapRoute)];
    [_mapView removeMapObject:loadMarker];
    [_mapView removeMapObject:unLoadMarker];
    
    loadMarker =
        [NMAMapMarker
         mapMarkerWithGeoCoordinates:[NMAGeoCoordinates geoCoordinatesWithLatitude:[[_routeParams objectForKey:@"OriginLat"] doubleValue]
                                                                         longitude:[[_routeParams objectForKey:@"OriginLng"] doubleValue]]
         image:[UIImage imageNamed:@"load80.png"]];
        [loadMarker setAnchorOffset: CGPointMake(00.0, -35.0)];
    unLoadMarker =
        [NMAMapMarker
         mapMarkerWithGeoCoordinates:[NMAGeoCoordinates geoCoordinatesWithLatitude:[[_routeParams objectForKey:@"DestinationLat"] doubleValue]
                                                                         longitude:[[_routeParams objectForKey:@"DestinationLng"] doubleValue]]
         image:[UIImage imageNamed:@"unload80.png"]];
        [unLoadMarker setAnchorOffset: CGPointMake(00.0, -35.0)];
    
    
    [_mapView addMapObject:loadMarker];
    [_mapView addMapObject:unLoadMarker];
    
    
    // Create an NSMutableArray to add two stops
    NSMutableArray* stops = [[NSMutableArray alloc] initWithCapacity:4];
    
    // START: 4350 Still Creek Dr
    NMAGeoCoordinates* hereBurnaby =
    [[NMAGeoCoordinates alloc] initWithLatitude: [[_routeParams objectForKey:@"OriginLat"] doubleValue] longitude: [[_routeParams objectForKey:@"OriginLng"] doubleValue]];
    // END: Langley BC
    NMAGeoCoordinates* langley =
    [[NMAGeoCoordinates alloc] initWithLatitude:[[_routeParams objectForKey:@"DestinationLat"] doubleValue] longitude:[[_routeParams objectForKey:@"DestinationLng"] doubleValue]];
    [stops addObject:hereBurnaby];
    [stops addObject:langley];
    
    // Create an NMARoutingMode, then set it to find the fastest car route without going on Highway.
    NMARoutingMode* routingMode =
    [[NMARoutingMode alloc] initWithRoutingType:NMARoutingTypeFastest
                                  transportMode:NMATransportModeCar
                                 routingOptions:NMATransitRoutingOptionAvoidAerial
                                    ];
    
    // Initialize the NMACoreRouter
    if ( !router )
    {
        router = [[NMACoreRouter alloc] init];
    }
    
    // Trigger the route calculation
    [router
     calculateRouteWithStops:stops
     routingMode:routingMode
     completionBlock:^( NMARouteResult* routeResult, NMARoutingError error ) {
         if ( !error )
         {
             if ( routeResult && routeResult.routes.count >= 1 )
             {
                 // Let's add the 1st result onto the map
                 self.route1 = routeResult.routes[0];
                 self->mapRoute = [NMAMapRoute mapRouteWithRoute:self.route1];
                 [self->_mapView addMapObject: self->mapRoute];
                 
                 // In order to see the entire route, we orientate the map view
                 NMAGeoCoordinates *topLeft =
                 [[NMAGeoCoordinates alloc]
                  
                  initWithLatitude:self.route1.boundingBox.topLeft.latitude+(self.route1.boundingBox.topLeft.latitude-self.route1.boundingBox.bottomRight.latitude)*0.85
                  
                  longitude:self.route1.boundingBox.topLeft.longitude];
                 
                 NMAGeoCoordinates *bottomRight =
                 [[NMAGeoCoordinates alloc]
                  initWithLatitude:self.route1.boundingBox.bottomRight.latitude-(self.route1.boundingBox.topLeft.latitude-self.route1.boundingBox.bottomRight.latitude)*0.25
                  
                  longitude:self.route1.boundingBox.bottomRight.longitude];
                 NMAGeoBoundingBox *NewBoundingBox =
                 [NMAGeoBoundingBox
                  geoBoundingBoxWithTopLeft:topLeft bottomRight:bottomRight];
                 
                 
                 [self->_mapView setBoundingBox:NewBoundingBox
                                withAnimation:NMAMapAnimationLinear];
                 
             }
             else
             {
                 NSLog( @"Error:route result returned is not valid" );
             }
         }
         else
         {
             NSLog( @"Error:route calculation returned error code %d", (int)error );
         }
     }];
    
    
}




- (void)startNavigation
{
    
    _mapView.positionIndicator.visible = YES;
    // Configure NavigationManager to launch navigation on current map
    [navigationManager setMap:_mapView];
    
    // Display the position indicator on map
    _mapView.positionIndicator.visible = YES;
    _mapView.positionIndicator.accuracyIndicatorVisible = YES;
    
    NMARoutePositionSource *source = [[NMARoutePositionSource alloc] initWithRoute:self.route1];
    source.movementSpeed = 60;
    [NMAPositioningManager sharedPositioningManager].dataSource = source;
    // Set the map tracking properties
    [NMANavigationManager sharedNavigationManager].mapTrackingEnabled = YES;
    [NMANavigationManager sharedNavigationManager].mapTrackingAutoZoomEnabled = YES;
    [NMANavigationManager sharedNavigationManager].mapTrackingOrientation
    = NMAMapTrackingOrientationDynamic;
    [NMANavigationManager sharedNavigationManager].speedWarningEnabled = YES;
    [navigationManager startTurnByTurnNavigationWithRoute:self.route1];
     printf("navStarted");

}

- (void)stopNavigation
{
    [navigationManager stop];
    NMAGeoCoordinates *topLeft =
    [[NMAGeoCoordinates alloc]

     initWithLatitude:self.route1.boundingBox.topLeft.latitude

     longitude:self.route1.boundingBox.topLeft.longitude];

    NMAGeoCoordinates *bottomRight =
    [[NMAGeoCoordinates alloc]
     initWithLatitude:self.route1.boundingBox.bottomRight.latitude

     longitude:self.route1.boundingBox.bottomRight.longitude];
    NMAGeoBoundingBox *NewBoundingBox =
    [NMAGeoBoundingBox
     geoBoundingBoxWithTopLeft:topLeft bottomRight:bottomRight];
    
    
    [self->_mapView setBoundingBox:NewBoundingBox
                     withAnimation:NMAMapAnimationLinear];
    [self.mapView setOrientation:0];
}

// Signifies that there is new instruction information available
- (void)navigationManager:(NMANavigationManager*)navigationManager
       hasCurrentManeuver:(NMAManeuver*)maneuver
             nextManeuver:(NMAManeuver*)nextManeuver
{
    printf("New maneuver is available");
}

// Signifies that the system has found a GPS signal
- (void)navigationManagerDidFindPosition:(NMANavigationManager*)navigationManager
{
    printf("New position is available");
}


- (void)showMessage:(NSString*)message
{
    CGRect frame = CGRectMake( 110, 200, 220, 120 );
    
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    label.textColor = [UIColor blueColor];
    label.text = message;
    label.numberOfLines = 0;
    
    CGRect rect = [[label text]
                   boundingRectWithSize:frame.size
                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                   attributes:@{
                                NSFontAttributeName : label.font
                                }
                   context:nil];
    frame.size = rect.size;
    label.frame = frame;
    
    [self addSubview:label];
    
    [UIView animateWithDuration:2.0
                     animations:^{
                         label.alpha = 0;
                     }
                     completion:^( BOOL finished ) {
                         [label removeFromSuperview];
                     }];
}


- (void)removeFromSuperview
{
  
  [_mapView removeObserver:self forKeyPath:@"currentFrameIndex"];
  _eventDispatcher = nil;
  _mapView = nil;
  [super removeFromSuperview];
}




/*-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if(object == _mapView) {
        _eventCounter++;
        if ([keyPath isEqualToString:@"coords"]) {
            [_eventDispatcher sendTextEventWithType:RCTTextEventTypeChange reactTag: self.reactTag text:self.text key:nil eventCount:_eventCounter]
        }
    }
}
*/

@end

//
//  HXStoreDocumentLibraryPDFViewController.m
//  HXStoreDocumentLibrary_Example
//
//  Created by J006 on 16/9/19.
//  Copyright © 2016年 com.huanxiao. All rights reserved.
//

#import "HXStoreDocumentLibraryPDFViewController.h"

//views
#import "ReaderContentView.h"

//other
#import "HXStoreDocumentLibraryImport.h"

//pdf source

#import "ReaderThumbCache.h"
#import "ReaderThumbQueue.h"

@interface HXStoreDocumentLibraryPDFViewController ()<UIScrollViewDelegate,
                                                      UIGestureRecognizerDelegate,
                                                      ReaderContentViewDelegate>

@property (nonatomic, assign) CGFloat               scrollViewOutset;
@property (nonatomic, strong) NSMutableDictionary   *contentViewsDic;
@property (nonatomic, assign) NSInteger             currentPage;
@property (nonatomic, assign) NSInteger             minimumPage;
@property (nonatomic, assign) NSInteger             maximumPage;
@property (nonatomic, assign) CGSize                lastAppearSize;
@property (nonatomic, strong) NSDate                *lastHideTime;
@property (nonatomic, assign) BOOL                  ignoreDidScroll;
@property (weak, nonatomic) IBOutlet UILabel        *pageContentLabel;
@property (nonatomic, assign) BOOL                  isAnimationContentLabel;

@end

@implementation HXStoreDocumentLibraryPDFViewController
{
    UIUserInterfaceIdiom userInterfaceIdiom;
    
    UIDocumentInteractionController *documentInteraction;
    
    UIPrintInteractionController *printInteraction;
}

#pragma mark - Constants

#define STATUS_HEIGHT 20.0f

#define TOOLBAR_HEIGHT 44.0f
#define PAGEBAR_HEIGHT 48.0f

#define SCROLLVIEW_OUTSET_SMALL 4.0f
#define SCROLLVIEW_OUTSET_LARGE 8.0f

#define TAP_AREA_SIZE 48.0f

#pragma mark - Properties

@synthesize delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self  initSetting];
}

- (void)viewDidUnload
{
#ifdef DEBUG
    DLog(@"%s", __FUNCTION__);
#endif
    _mainScrollView = nil;
    _contentViewsDic = nil;
    _lastHideTime = nil;
    
    //_documentInteraction = nil;
    //_printInteraction = nil;
    
    _lastAppearSize = CGSizeZero;
    _currentPage = 0;
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
    DLog(@"%s", __FUNCTION__);
#endif
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (CGSizeEqualToSize(_lastAppearSize, CGSizeZero) == false)
    {
        if (CGSizeEqualToSize(_lastAppearSize, self.view.bounds.size) == false)
        {
            [self updateContentViews:_mainScrollView]; // Update content views
        }
        
        _lastAppearSize = CGSizeZero; // Reset view size tracking
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (CGSizeEqualToSize(_mainScrollView.contentSize, CGSizeZero) == true)
    {
        [self performSelector:@selector(showDocument)
                   withObject:nil
                   afterDelay:0.0];
    }
    
#if (READER_DISABLE_IDLE == TRUE) // Option
    
    //[UIApplication sharedApplication].idleTimerDisabled = YES;
    
#endif // end of READER_DISABLE_IDLE Option
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _lastAppearSize = self.view.bounds.size; // Track view size
    
#if (READER_DISABLE_IDLE == TRUE) // Option
    
    //[UIApplication sharedApplication].idleTimerDisabled = NO;
    
#endif // end of READER_DISABLE_IDLE Option
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - init

- (void)initSetting
{
    if(!_document) {
        return;
    }
    _scrollViewOutset = SCROLLVIEW_OUTSET_SMALL;
    [_document updateDocumentProperties];
    [ReaderThumbCache touchThumbCacheWithGUID:_document.guid];
    _minimumPage = 1;
    _maximumPage = [_document.pageCount integerValue];
    [self initGesture];
    [self initPageContentLabel];
//    _mainScrollView.autoresizesSubviews = NO;
//    _mainScrollView.contentMode = UIViewContentModeRedraw;
//    _mainScrollView.showsHorizontalScrollIndicator = NO;
//    _mainScrollView.showsVerticalScrollIndicator = NO;
//    _mainScrollView.scrollsToTop = NO;
//    _mainScrollView.delaysContentTouches = NO;
    _mainScrollView.pagingEnabled = YES;
//    _mainScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    
}

- (void)initPageContentLabel
{
    if(_document) {
        _pageContentLabel.layer.borderColor = [UIColor colorWithRGBHex:0x333333].CGColor;
        _pageContentLabel.layer.borderWidth = 0.5;
        _pageContentLabel.layer.cornerRadius = 12;
        [_pageContentLabel.layer setMasksToBounds:YES];
    }
    
    if(_isNotNeedToShowPageLabel) {
        [_pageContentLabel setHidden:YES];
    } else {
        [_pageContentLabel setHidden:NO];
    }
}

- (void)initGesture
{
    UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
    [self.view addGestureRecognizer:singleTapOne];
    
    UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapOne.numberOfTouchesRequired = 1; doubleTapOne.numberOfTapsRequired = 2; doubleTapOne.delegate = self;
    [self.view addGestureRecognizer:doubleTapOne];
    
    UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapTwo.numberOfTouchesRequired = 2; doubleTapTwo.numberOfTapsRequired = 2; doubleTapTwo.delegate = self;
    [self.view addGestureRecognizer:doubleTapTwo];
    
    [singleTapOne requireGestureRecognizerToFail:doubleTapOne];
}

#pragma mark - create

+ (instancetype)createPDFViewVCWithReaderDocument:(ReaderDocument *)readerDoc
{
    HXStoreDocumentLibraryPDFViewController *vc = [HXStoreDocumentLibraryPDFViewController controllerFromXibWithModuleName:@"HXStoreDocumentLibrary"];
    if ((readerDoc != nil)
        && ([readerDoc isKindOfClass:[ReaderDocument class]])) {
        vc.document = readerDoc;
    }
    
    return vc;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_ignoreDidScroll == NO) {
        [self layoutContentViews:scrollView];
    }
    [self setPageNumsToContentLabel];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleScrollViewDidEnd:scrollView];
    
    [self setPageNumsToContentLabel];
    
    [self animationContentLabelToDisappear];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self handleScrollViewDidEnd:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self animationContentLabelToShow];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    
    return NO;
}


#pragma mark - UIGestureRecognizer action methods

- (void)decrementPageNumber
{
    if ((_maximumPage > _minimumPage)
        && (_currentPage != _minimumPage))
    {
        CGPoint contentOffset = _mainScrollView.contentOffset; // Offset
        
        contentOffset.y -= _mainScrollView.bounds.size.height; // View Y--
        
        [_mainScrollView setContentOffset:contentOffset animated:YES];
    }
}

- (void)incrementPageNumber
{
    if ((_maximumPage > _minimumPage)
        && (_currentPage != _maximumPage))
    {
        CGPoint contentOffset = _mainScrollView.contentOffset; // Offset
        
        contentOffset.y += _mainScrollView.bounds.size.height; // View Y++
        
        [_mainScrollView setContentOffset:contentOffset animated:YES];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGRect viewRect = recognizer.view.bounds; // View bounds
        
        CGPoint point = [recognizer locationInView:recognizer.view]; // Point
        
        CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area rect
        
        if (CGRectContainsPoint(areaRect, point)) // Single tap is inside area
        {
            NSNumber *key = [NSNumber numberWithInteger:_currentPage]; // Page number key
            
            ReaderContentView *targetView = [_contentViewsDic objectForKey:key]; // View
            
            id target = [targetView processSingleTap:recognizer]; // Target object
            
            if (target != nil) // Handle the returned target object
            {
                if ([target isKindOfClass:[NSURL class]]) // Open a URL
                {
                    NSURL *url = (NSURL *)target; // Cast to a NSURL object
                    
                    if (url.scheme == nil) // Handle a missing URL scheme
                    {
                        NSString *www = url.absoluteString; // Get URL string
                        
                        if ([www hasPrefix:@"www"] == YES) // Check for 'www' prefix
                        {
                            NSString *http = [[NSString alloc] initWithFormat:@"http://%@", www];
                            
                            url = [NSURL URLWithString:http]; // Proper http-based URL
                        }
                    }
                    
                    if ([[UIApplication sharedApplication] openURL:url] == NO)
                    {
#ifdef DEBUG
                        DLog(@"%s '%@'", __FUNCTION__, url); // Bad or unknown URL
#endif
                    }
                }
                else // Not a URL, so check for another possible object type
                {
                    if ([target isKindOfClass:[NSNumber class]]) // Goto page
                    {
                        NSInteger number = [target integerValue]; // Number
                        
                        [self showDocumentPage:number]; // Show the page
                    }
                }
            }
            else // Nothing active tapped in the target content view
            {
                /*
                if ([lastHideTime timeIntervalSinceNow] < -0.75) // Delay since hide
                {
                    if ((mainToolbar.alpha < 1.0f) || (mainPagebar.alpha < 1.0f)) // Hidden
                    {
                        [mainToolbar showToolbar]; [mainPagebar showPagebar]; // Show
                    }
                }
                 */
            }
            
            return;
        }
        
        CGRect nextPageRect = viewRect;
        nextPageRect.size.width = TAP_AREA_SIZE;
        nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
        
        if (CGRectContainsPoint(nextPageRect, point) == true) // page++
        {
            [self incrementPageNumber];
            return;
        }
        
        CGRect prevPageRect = viewRect;
        prevPageRect.size.width = TAP_AREA_SIZE;
        
        if (CGRectContainsPoint(prevPageRect, point) == true) // page--
        {
            [self decrementPageNumber];
            return;
        }
    }
}


- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGRect viewRect = recognizer.view.bounds; // View bounds
        
        CGPoint point = [recognizer locationInView:recognizer.view]; // Point
        
        CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE); // Area
        
        if (CGRectContainsPoint(zoomArea, point)) // Double tap is inside zoom area
        {
            NSNumber *key = [NSNumber numberWithInteger:_currentPage]; // Page number key
            
            ReaderContentView *targetView = [_contentViewsDic objectForKey:key]; // View
            
            switch (recognizer.numberOfTouchesRequired) // Touches count
            {
                case 1: // One finger double tap: zoom++
                {
                    [targetView zoomIncrement:recognizer];
                    break;
                }
                    
                case 2: // Two finger double tap: zoom--
                {
                    [targetView zoomDecrement:recognizer];
                    break;
                }
            }
            
            return;
        }
        
        CGRect nextPageRect = viewRect;
        nextPageRect.size.width = TAP_AREA_SIZE;
        nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
        
        if (CGRectContainsPoint(nextPageRect, point)) // page++
        {
            [self incrementPageNumber]; return;
        }
        
        CGRect prevPageRect = viewRect;
        prevPageRect.size.width = TAP_AREA_SIZE;
        
        if (CGRectContainsPoint(prevPageRect, point)) // page--
        {
            [self decrementPageNumber]; return;
        }
    }
}


#pragma mark - private methods

- (void)contentView:(ReaderContentView *)contentView touchesBegan:(NSSet *)touches
{
    if (touches.count == 1) // Single touches only
    {
        UITouch *touch = [touches anyObject]; // Touch info
        
        CGPoint point = [touch locationInView:self.view]; // Touch location
        
        CGRect areaRect = CGRectInset(self.view.bounds, TAP_AREA_SIZE, TAP_AREA_SIZE);
        
        if (!CGRectContainsPoint(areaRect, point)) {
            return;
        }
    }
    
    _lastHideTime = [NSDate date]; // Set last hide time
}


- (void)updateContentSize:(UIScrollView *)scrollView
{
    CGFloat contentHeight = scrollView.bounds.size.height * _maximumPage; // Height
    
    CGFloat contentWidth = scrollView.bounds.size.width;
    
    scrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)updateContentViews:(UIScrollView *)scrollView
{
    [self updateContentSize:scrollView]; // Update content size first
    WS(weakSelf);
    [_contentViewsDic enumerateKeysAndObjectsUsingBlock: // Enumerate content views
     ^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
     {
         NSInteger page = [key integerValue]; // Page number value
         
         CGRect viewRect = CGRectZero;
         viewRect.size = scrollView.bounds.size;
         viewRect.origin.y = (viewRect.size.height * (page - 1)); // Update Y
         
         contentView.frame = CGRectInset(viewRect, 0.0f, weakSelf.scrollViewOutset);
     }
     ];
    
    NSInteger page = _currentPage; // Update scroll view offset to current page
    
    CGPoint contentOffset = CGPointMake(0.0f, (scrollView.bounds.size.height * (page - 1)));
    
    if (CGPointEqualToPoint(scrollView.contentOffset, contentOffset) == false) // Update
    {
        scrollView.contentOffset = contentOffset; // Update content offset
    }
}

- (void)addContentView:(UIScrollView *)scrollView page:(NSInteger)page
{
    CGRect viewRect = CGRectZero;
    viewRect.size = scrollView.bounds.size;
    
    viewRect.origin.y = (viewRect.size.height * (page - 1));
    viewRect = CGRectInset(viewRect, 0.0f, _scrollViewOutset);
    
    NSURL       *fileURL = _document.fileURL;
    NSString    *phrase  = _document.password;
    NSString    *guid    = _document.guid; // Document properties
    
    ReaderContentView *contentView = [[ReaderContentView alloc] initWithFrame:viewRect
                                                                      fileURL:fileURL
                                                                         page:page
                                                                     password:phrase]; // ReaderContentView
    
    contentView.message = self;
    [_contentViewsDic setObject:contentView
                         forKey:[NSNumber numberWithInteger:page]];
    [scrollView addSubview:contentView];
    
    [contentView showPageThumb:fileURL page:page password:phrase guid:guid]; // Request page preview thumb
}

- (void)layoutContentViews:(UIScrollView *)scrollView
{
    CGFloat viewHeight = scrollView.bounds.size.height; // View height
    
    CGFloat contentOffsetY = scrollView.contentOffset.y; // Content offset X
    
    NSInteger pageB = ((contentOffsetY + viewHeight - 1.0f) / viewHeight); // Pages
    
    NSInteger pageA = (contentOffsetY / viewHeight);
    pageB += 2; // Add extra pages
    
    if (pageA < _minimumPage) pageA = _minimumPage; if (pageB > _maximumPage) pageB = _maximumPage;
    
    NSRange pageRange = NSMakeRange(pageA, (pageB - pageA + 1)); // Make page range (A to B)
    
    NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSetWithIndexesInRange:pageRange];
    
    for (NSNumber *key in [_contentViewsDic allKeys]) // Enumerate content views
    {
        NSInteger page = [key integerValue]; // Page number value
        
        if ([pageSet containsIndex:page] == NO) // Remove content view
        {
            ReaderContentView *contentView = [_contentViewsDic objectForKey:key];
            
            [contentView removeFromSuperview]; [_contentViewsDic removeObjectForKey:key];
        }
        else // Visible content view - so remove it from page set
        {
            [pageSet removeIndex:page];
        }
    }
    
    NSInteger pages = pageSet.count;
    
    if (pages > 0) // We have pages to add
    {
        NSEnumerationOptions options = 0; // Default
        
        if (pages == 2) // Handle case of only two content views
        {
            if ((_maximumPage > 2) && ([pageSet lastIndex] == _maximumPage))
                options = NSEnumerationReverse;
        }
        else if (pages == 3) // Handle three content views - show the middle one first
        {
            NSMutableIndexSet *workSet = [pageSet mutableCopy]; options = NSEnumerationReverse;
            
            [workSet removeIndex:[pageSet firstIndex]]; [workSet removeIndex:[pageSet lastIndex]];
            
            NSInteger page = [workSet firstIndex]; [pageSet removeIndex:page];
            
            [self addContentView:scrollView page:page];
        }
        
        [pageSet enumerateIndexesWithOptions:options usingBlock: // Enumerate page set
         ^(NSUInteger page, BOOL *stop)
         {
             [self addContentView:scrollView page:page];
         }
         ];
    }
}

- (void)handleScrollViewDidEnd:(UIScrollView *)scrollView
{
    CGFloat viewHeight = scrollView.bounds.size.height; // Scroll view height
    
    CGFloat contentOffsetY = scrollView.contentOffset.y; // Content offset X
    
    NSInteger page = (contentOffsetY / viewHeight); page++; // Page number
    
    if (page != _currentPage) // Only if on different page
    {
        _currentPage = page;
        _document.pageNumber = [NSNumber numberWithInteger:page];
        
        [self.contentViewsDic enumerateKeysAndObjectsUsingBlock: // Enumerate content views
         ^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
         {
             if ([key integerValue] != page) {
                 [contentView zoomResetAnimated:NO];
             }
         }];
    }
}

- (void)showDocumentPage:(NSInteger)page
{
    if (page != _currentPage) // Only if on different page
    {
        if ((page < _minimumPage) || (page > _maximumPage)) {
            return;
        }
        
        _currentPage = page;
        _document.pageNumber = [NSNumber numberWithInteger:page];
        
        CGPoint contentOffset = CGPointMake(0.0f, (_mainScrollView.bounds.size.height * (page - 1)));
        
        if (CGPointEqualToPoint(_mainScrollView.contentOffset, contentOffset) == true)
            [self layoutContentViews:_mainScrollView];
        else
            [_mainScrollView setContentOffset:contentOffset];
        
        [self.contentViewsDic enumerateKeysAndObjectsUsingBlock: // Enumerate content views
         ^(NSNumber *key, ReaderContentView *contentView, BOOL *stop)
         {
             if ([key integerValue] != page) [contentView zoomResetAnimated:NO];
         }
         ];
    }
}

- (void)showDocument
{
    [self updateContentSize:_mainScrollView]; // Update content size first
    
    [self showDocumentPage:[_document.pageNumber integerValue]]; // Show page
    
    _document.lastOpen = [NSDate date]; // Update document last opened date
}

- (void)closeDocument
{
    if (printInteraction != nil){
        [printInteraction dismissAnimated:NO];
    }
    
    [_document archiveDocumentProperties]; // Save any ReaderDocument changes
    
    [[ReaderThumbQueue sharedInstance] cancelOperationsWithGUID:_document.guid];
    
    [[ReaderThumbCache sharedInstance] removeAllObjects]; // Empty the thumb cache
    
    if ([delegate respondsToSelector:@selector(dismissReaderViewController:)] == YES)
    {
        [delegate dismissReaderViewController:self]; // Dismiss the ReaderViewController
    }
    else // We have a "Delegate must respond to -dismissReaderViewController:" error
    {
        NSAssert(NO, @"Delegate must respond to -dismissReaderViewController:");
    }
}


#pragma mark - Animation

- (void)animationContentLabelToShow
{
    if(_pageContentLabel.alpha == 0.0
       && !_isAnimationContentLabel) {
        _isAnimationContentLabel = YES;
        [UIView animateWithDuration:0.5 animations:^{
            _pageContentLabel.alpha = 1.0;
        } completion:^(BOOL finished) {
            _isAnimationContentLabel = NO;
        }];
    }
}

- (void)setPageNumsToContentLabel
{
    NSString *pageContent = [NSString stringWithFormat:@"%@/%@",[_document.pageNumber stringValue],[_document.pageCount stringValue]];
    [_pageContentLabel setText:pageContent];
}

- (void)animationContentLabelToDisappear
{
    _isAnimationContentLabel = YES;
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _pageContentLabel.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         _isAnimationContentLabel = NO;
                     }];
}


#pragma mark - getter

- (NSMutableDictionary *)contentViewsDic
{
    if(nil == _contentViewsDic) {
        _contentViewsDic = [[NSMutableDictionary alloc]init];
    }
    
    return _contentViewsDic;
}

- (NSDate *)lastHideTime
{
    if(nil == _lastHideTime) {
        _lastHideTime = [NSDate new];
    }
    
    return _lastHideTime;
}

@end

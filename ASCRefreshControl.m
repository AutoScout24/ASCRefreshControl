//  ASCRefreshControl
//
//  Created by Felix Schulze on 8/26/2013.
//  Copyright 2013 AutoScout24 GmbH. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "ASCRefreshControl.h"
#import "ODRefreshControl.h"

@implementation ASCRefreshControl {
    UIScrollView *scrollView;
}

- (id)initWithTableView:(UITableView *)theTableView {
    self = [super init];
    if (self) {

        scrollView = theTableView;

        if (NSClassFromString(@"UIRefreshControl")) {
            // Use iOS 6 implementation
            refreshControl = [[UIRefreshControl alloc] init];
            [scrollView addSubview:refreshControl];
        }
        else {
            // Use Open Source implementation
            refreshControl = [[ODRefreshControl alloc] initInScrollView:scrollView];
        }

        [refreshControl addTarget:self action:@selector(refreshControlDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }

    return self;
}

- (void)dealloc {
    [refreshControl removeFromSuperview];
    refreshControl = nil;
}

- (void)beginRefreshing {
    [refreshControl beginRefreshing];

    [scrollView setContentOffset:CGPointMake(0, -44) animated:NO];

    [_delegate refreshControlDidBeginRefreshing:self];
}

- (void)endRefreshing {

    [refreshControl endRefreshing];

    if (NSClassFromString(@"UIRefreshControl")) {
        __weak UIScrollView *scrollViewForBlock = scrollView;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
            [scrollViewForBlock setContentOffset:CGPointMake(0, 0) animated:YES];
        });
    }
}

- (BOOL)refreshing {
    if (!NSClassFromString(@"UIRefreshControl")) {
        return [refreshControl refreshing];
    }
    return [refreshControl isRefreshing];
}

- (void)setTintColor:(UIColor *)theTintColor {
    [refreshControl setTintColor:theTintColor];
}

- (UIColor *)tintColor {
    return [refreshControl tintColor];
}

- (void)refreshControlDidBeginRefreshing:(id)theRefreshControl {
    [_delegate refreshControlDidBeginRefreshing:self];
}


@end
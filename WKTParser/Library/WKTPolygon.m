//
//  WKTPolygon.m
//
//  WKTParser Polygon
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Alejandro Fdez Carrera
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#include "WKTPolygon.h"

@implementation WKTPolygon

- (id)init
{
    if (self == nil)
    {
        self = [super init];
        self.type = @"Polygon";
        self.dimensions = 0;
        listMultiPoints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithMultiPoints:(NSArray *)multiPoints
{
    if (self == nil)
    {
        self = [self init];
    }
    [self removePolygons];
    [self setPolygons:multiPoints];
    return self;
}

- (void)setPolygons:(NSArray *)multiPoints
{
    if(multiPoints == nil)
    {
        @throw [NSException exceptionWithName:@"WKTParser Polygon"
            reason:@"Parameter Multi Points list is nil"
            userInfo:nil];
    }
    else
    {
        int dimBackup = 0;
        for(int i = 0; i < multiPoints.count; i++)
        {
            if(![multiPoints[i] isKindOfClass:[WKTPointM class]])
            {
                @throw [NSException exceptionWithName:@"WKTParser Polygon"
                    reason:@"Parameter points have a class that is not WKTMultiPoint"
                    userInfo:nil];
            }
            else
            {
                if(i == 0)
                {
                    dimBackup = [(WKTPointM *) multiPoints[0] dimensions];
                    [listMultiPoints addObject:multiPoints[0]];
                }
                else if(dimBackup != [(WKTPointM *) multiPoints[i] dimensions])
                {
                    @throw [NSException exceptionWithName:@"WKTParser Polygon"
                        reason:@"Parameter Multi Points list have WKTMultiPoint with \
                        different dimensions" userInfo:nil];
                }
                else
                {
                    [listMultiPoints addObject:multiPoints[i]];
                }
            }
        }
        self.dimensions = dimBackup;
    }
}

- (NSArray *)getPolygon
{
    return listMultiPoints;
}

- (NSArray *)getInteriorPolygons
{
    if(listMultiPoints.count > 1)
    {
        NSMutableArray *polygonsI = [[NSMutableArray alloc] init];
        for(int i = 1; i < listMultiPoints.count; i++)
        {
            [polygonsI addObject:listMultiPoints[i]];
        }
        return polygonsI;
    }
    else
    {
        return [[NSArray alloc] init];
    }
}

- (WKTPointM *)getExteriorPolygon
{
    if(listMultiPoints.count > 0)
    {
        return listMultiPoints[0];
    }
    else
    {
        return [[WKTPointM alloc] init];
    }
}

- (void)removePolygons
{
    [listMultiPoints removeAllObjects];
    self.dimensions = 0;
}

- (void)copyTo:(WKTPolygon *)otherPolygon
{
    if(otherPolygon == nil)
    {
        @throw [NSException exceptionWithName:@"WKTParser Polygon [copyTo]"
            reason:@"Parameter Polygon is nil"
            userInfo:nil];
    }
    else
    {
        otherPolygon.type = self.type;
        otherPolygon.dimensions = self.dimensions;
        [otherPolygon removePolygons];
        [otherPolygon setPolygons: listMultiPoints];
    }
}

@end
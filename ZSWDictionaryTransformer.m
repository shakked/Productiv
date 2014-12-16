//
//  ZSWDictionaryTransformer.m
//  Productiv
//
//  Created by Zachary Shakked on 7/23/14.
//  Copyright (c) 2014 Productiv. All rights reserved.
//

#import "ZSWDictionaryTransformer.h"

@implementation ZSWDictionaryTransformer

+ (Class)transformedValueClass
{
    return [NSDictionary class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end

//
//  HHNote.m
//  LocationNotes
//
//  Created by Hunter Horsley on 4/4/14.
//  Copyright (c) 2014 HunterHorsley. All rights reserved.
//

#import "HHNote.h"


@implementation HHNote

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [self init]) {
        _noteTitle = [decoder decodeObjectForKey:@"noteTitle"];
        _noteDescription = [decoder decodeObjectForKey:@"noteDescription"];
        _noteComment = [decoder decodeObjectForKey:@"noteComment"];
        _noteImageURL = [decoder decodeObjectForKey:@"noteImageURL"];

        _noteLatitude = [[decoder decodeObjectForKey:@"noteLatitude"] floatValue];
        _noteLongitude = [[decoder decodeObjectForKey:@"noteLongitude"] floatValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_noteTitle forKey:@"noteTitle"];
    [coder encodeObject:_noteDescription forKey:@"noteDescription"];
    [coder encodeObject:_noteComment forKey:@"noteComment"];
    [coder encodeObject:_noteImageURL forKey:@"noteImageURL"];
    
    [coder encodeObject:@(_noteLatitude) forKey:@"noteLatitude"];
    [coder encodeObject:@(_noteLongitude) forKey:@"noteLongitude"];



}


@end

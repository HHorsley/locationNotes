//
//  HHNote.h
//  LocationNotes
//
//  Created by Hunter Horsley on 4/4/14.
//  Copyright (c) 2014 HunterHorsley. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HHNote : NSObject

@property (nonatomic, retain) NSString * noteTitle;
@property (nonatomic, retain) NSString * noteDescription;
@property (nonatomic, retain) NSString * noteComment;
@property (nonatomic, retain) NSString * noteImageURL;

@property (nonatomic) float noteLatitude;
@property (nonatomic) float noteLongitude;


@end

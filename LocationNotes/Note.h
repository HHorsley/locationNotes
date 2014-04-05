//
//  HHNote.h
//  LocationNotes
//
//  Created by Hunter Horsley on 4/2/14.
//  Copyright (c) 2014 HunterHorsley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Note : NSManagedObject

@property (nonatomic, retain) NSString * noteTitle;
@property (nonatomic, retain) NSString * noteDescription;
@property (nonatomic, retain) NSString * noteComment;
@property (nonatomic, retain) NSNumber * noteLatitude;
@property (nonatomic, retain) NSNumber * noteLongitude;

@end

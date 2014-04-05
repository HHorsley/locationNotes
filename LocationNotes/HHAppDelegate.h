//
//  HHAppDelegate.h
//  LocationNotes
//
//  Created by Hunter Horsley on 3/31/14.
//  Copyright (c) 2014 HunterHorsley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHNote.h"
#import "Note.h"

@interface HHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//Core Data
- (BOOL)addNoteFromWrapper:(HHNote*)note;
//- (BOOL)checkIfAlreadyRegistered:(HHNote*)note;
- (NSArray*)loadAllNotes;
- (BOOL)deleteNoteFromWrapper:(HHNote*)note;


@end

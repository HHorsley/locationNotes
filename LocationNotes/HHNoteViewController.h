//
//  HHNoteViewController.h
//  LocationNotes
//
//  Created by Hunter Horsley on 4/4/14.
//  Copyright (c) 2014 HunterHorsley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHNoteViewController : UIViewController

@property(nonatomic, strong) NSString *noteTitle;
@property(nonatomic, strong) NSString *noteDescription;
@property(nonatomic, strong) NSString *noteComment;
@property(nonatomic, strong) NSString *noteImageURL;


@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteCommentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noteImageToShow;



@end

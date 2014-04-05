//
//  HHNoteViewController.m
//  LocationNotes
//
//  Created by Hunter Horsley on 4/4/14.
//  Copyright (c) 2014 HunterHorsley. All rights reserved.
//

#import "HHNoteViewController.h"

@interface HHNoteViewController ()

@end

@implementation HHNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _noteTitleLabel.text = _noteTitle;
    _noteDescriptionLabel.text = _noteDescription;
    _noteCommentLabel.text = _noteComment;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

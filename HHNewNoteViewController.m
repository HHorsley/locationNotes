//
//  HHNewNoteViewController.m
//  LocationNotes
//
//  Created by Hunter Horsley on 4/2/14.
//  Copyright (c) 2014 HunterHorsley. All rights reserved.
//

#import "HHNewNoteViewController.h"
#import "HHNote.h"
#import "HHAppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface HHNewNoteViewController () <UIActionSheetDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

{
IBOutlet UITextField *titleField;
IBOutlet UITextField *descriptionField;
IBOutlet UITextField *commentField;
}
@property (weak, nonatomic) IBOutlet UILabel *longitudeDisplayField;
@property (weak, nonatomic) IBOutlet UILabel *latitudeDisplayField;

- (IBAction)createNote:(id)sender;

//delegates
@property (nonatomic, strong) HHAppDelegate *appDelegate;
@property (nonatomic, strong) CLLocationManager *locationManager;

//Keyboard stuff
@property (nonatomic, strong) UIToolbar *keyboardToolbar;
@property (nonatomic, strong) UIBarButtonItem *previousButton;
@property (nonatomic, strong) UIBarButtonItem *nextButton;
- (void) nextField;
- (void) previousField;
- (void) resignKeyboard;

@end


@implementation HHNewNoteViewController

- (HHAppDelegate *)appDelegate
{
    if (!_appDelegate) {
        _appDelegate = (HHAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// setup the keyboard toolbar
- (UIToolbar *)keyboardToolbar
{
    if (!_keyboardToolbar) {
        _keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        self.previousButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(previousField)];
        
        self.nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                           style:UIBarButtonItemStyleBordered
                                                          target:self
                                                          action:@selector(nextField)];
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:self
                                                                                    action:nil];
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"That's it!"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(resignKeyboard)];
        
        [_keyboardToolbar setItems:@[self.previousButton, self.nextButton, extraSpace, doneButton]];
    }
    
    return _keyboardToolbar;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Loading View");
	titleField.inputAccessoryView = self.keyboardToolbar;
    descriptionField.inputAccessoryView = self.keyboardToolbar;
    commentField.inputAccessoryView = self.keyboardToolbar;
    
    //display location
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinates = [location coordinate];
    NSNumber *longitudeNumer = [NSNumber numberWithDouble:coordinates.longitude ];
    NSNumber *latitudeNumer = [NSNumber numberWithDouble:coordinates.latitude ];
    _longitudeDisplayField.text = [longitudeNumer stringValue];
    _latitudeDisplayField.text = [latitudeNumer stringValue];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - submitNote

- (IBAction)createNote:(id)sender
{
    HHNote *newNoteToAdd = [[HHNote alloc] init];
    newNoteToAdd.noteTitle = titleField.text;
    newNoteToAdd.noteDescription = descriptionField.text;
    newNoteToAdd.noteComment = commentField.text;
    
    // get location
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinates = [location coordinate];
    newNoteToAdd.noteLatitude = coordinates.latitude;
    newNoteToAdd.noteLongitude = coordinates.longitude;
    
    if ([self.appDelegate addNoteFromWrapper:newNoteToAdd]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        UIAlertView *damnAnError = [[UIAlertView alloc] initWithTitle:@"Ah! An error."
                                                              message:@"Idn, something just feels wrong. It's not you, it's me."
                                                             delegate:self
                                                    cancelButtonTitle:@"You're killin' me!"
                                                    otherButtonTitles:nil, nil];
        [damnAnError show];
    }
}


#pragma mark - ActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Keyboard stuff

- (void) nextField
{
    if ([titleField isFirstResponder]) {
        [descriptionField becomeFirstResponder];
    } else if ([descriptionField isFirstResponder]) {
        [commentField becomeFirstResponder];
    }
}

- (void) previousField
{
    if ([commentField isFirstResponder]) {
        [descriptionField becomeFirstResponder];
    } else if ([descriptionField isFirstResponder]) {
        [titleField becomeFirstResponder];
    }
}

- (void) resignKeyboard
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}


#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    
    if (textField == titleField) {
        self.previousButton.enabled = NO;
    } else {
        self.previousButton.enabled = YES;
    }
    
    if (textField == commentField) {
        self.nextButton.enabled = NO;
    } else {
        self.nextButton.enabled = YES;
    }
    
    if (textField == commentField) {
        viewFrame.origin.y = -180;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
    [textField resignFirstResponder];
    self.view.frame = viewFrame;
    
    [UIView commitAnimations];
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}




@end

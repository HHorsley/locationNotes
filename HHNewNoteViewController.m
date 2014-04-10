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

@interface HHNewNoteViewController () <UIActionSheetDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

{
IBOutlet UITextField *titleField;
IBOutlet UITextField *descriptionField;
IBOutlet UITextField *commentField;
}
@property (strong, nonatomic) NSString *pathOfImage;


@property (weak, nonatomic) IBOutlet UILabel *longitudeDisplayField;
@property (weak, nonatomic) IBOutlet UILabel *latitudeDisplayField;

- (IBAction)createNote:(id)sender;

//image stuff
@property (nonatomic, strong) IBOutlet UIImageView *chosenImage;
- (IBAction)choosePhoto:(id)sender;
- (void)takePicture;
- (void)choosePicture;

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
    NSLog(@"longitudeNum: %@", longitudeNumer);
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
    NSLog(@"pathofImage: %@", _pathOfImage);
    HHNote *newNoteToAdd = [[HHNote alloc] init];
    newNoteToAdd.noteTitle = titleField.text;
    newNoteToAdd.noteDescription = descriptionField.text;
    newNoteToAdd.noteComment = commentField.text;
    newNoteToAdd.noteImageURL = _pathOfImage;
    NSLog(@"noteImageURL: %@", newNoteToAdd.noteImageURL);

    
    // get location
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinates = [location coordinate];
    newNoteToAdd.noteLatitude = coordinates.latitude;
    NSLog(@"coordiantes.latitude: %f", coordinates.latitude);
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
    switch (buttonIndex)
    {
        case 0:
        {
            [self takePicture];
            break;
        }
        case 1:
            [self choosePicture];
            break;
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


#pragma mark - uploadImage

- (IBAction)choosePhoto:(id)sender
{
    UIActionSheet *choosePhoto = [[UIActionSheet alloc] initWithTitle:@"How do you want to select a picture?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Picture", @"Choose Picture", nil];
    [choosePhoto setTag:2];
    [choosePhoto showInView:self.view];
    

}


- (void)takePicture
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *noCamera = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:@"This device does not seem to have a camera."
                                                          delegate:self
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil, nil];
        [noCamera show];
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;

        
        [self presentViewController:picker
                           animated:YES
                         completion:nil];
    }
}

- (void)choosePicture
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker
                       animated:YES
                     completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.chosenImage.image = chosenImage;
    
    [self saveImageToDisk:self.chosenImage.image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    UIAlertView *noCamera = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                       message:@"Seems like picking a photo didn't really work out for you."
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil, nil];
    [noCamera show];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Core Data for adding Images

- (void)saveImageToDisk:(UIImage *)imageToSave
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docs = [paths objectAtIndex:0];
    
    NSInteger randomNumber = arc4random();
    
    NSString *path = [docs stringByAppendingFormat:@"/%@%d.jpg", titleField.text, randomNumber];
    _pathOfImage = path;
    
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(imageToSave, 80)];
    NSError *writeError = nil;
    [imageData writeToFile:path options:NSDataWritingAtomic error:&writeError];
    
    if(writeError!=nil) {
        NSLog(@"%@: Error saving image: %@", [self class], [writeError localizedDescription]);
    }
    
}




@end

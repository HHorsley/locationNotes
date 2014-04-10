Hunter Horsley - HW4
4/9/2014
CIS 195

I added functionality so that you can pick/take a photo, view a preview in the note, see a thumbnail of it in the pin annotation, and then see it in the detailed view of the note. This was accomplished by constructing a unique URL for the file and then adding that URL to my note data model as an NSString that I could pass around. The pin thumbnail was added by adding a left callout and then putting a custom imageview in it.


Hunter Horsley - HW3
4/4/2014
CIS 195

The app allows you to create notes that are associated with the geographical coordinates from where you are when you make the note. I used CLLocationManager to grab these coordiantes from the phone and save it with the "Note" object along with the note itself. A note is saved via a wrapper, which encodes the properties, as a managedObject in a managedObjectContext. You can view previously saved notes on the graphical map. Each note is represented by a pin, created with MKPinAnnotation, at the coordinates of the note. If you tap the note you get MKPinAnnotationView which shows a snippit of the note and then links you to the entire note. 
 
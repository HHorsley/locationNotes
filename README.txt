Hunter Horsley - HW3
4/4/2014
CIS 195

The app allows you to create notes that are associated with the geographical coordinates from where you are when you make the note. I used CLLocationManager to grab these coordiantes from the phone and save it with the "Note" object along with the note itself. A note is saved via a wrapper, which encodes the properties, as a managedObject in a managedObjectContext. You can view previously saved notes on the graphical map. Each note is represented by a pin, created with MKPinAnnotation, at the coordinates of the note. If you tap the note you get MKPinAnnotationView which shows a snippit of the note and then links you to the entire note. 

 
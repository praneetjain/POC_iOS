import UIKit
import CoreLocation
import CoreData

private let dateFormatter: NSDateFormatter = {
  let formatter = NSDateFormatter()
  formatter.dateStyle = .MediumStyle
  formatter.timeStyle = .ShortStyle
  return formatter
}()

class LocationDetailsViewController: UITableViewController {
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var addPhotoLabel : UILabel!
    var image : UIImage?
    var observer : AnyObject?
  
  var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  var placemark: CLPlacemark?
  var categoryName = "No Category"
    var descritionText = ""
    var date = NSDate()
    
    var managedObjectContext : NSManagedObjectContext!
    var locationToEdit : Location?{
    
        didSet{
            if let location = locationToEdit{
            
            descritionText = location.description
            placemark = location.placemark
            date = location.date
            coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            }
        }
    }

    func showImage(image: UIImage) {
        imageView.image = image
        imageView.hidden = false
        imageView.frame = CGRect(x: 10, y: 10, width: 260, height: 260)
        addPhotoLabel.hidden = true
    }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    listenForBackgroundNotification()
    
    if let location = locationToEdit{
    
        title = "Edit Location"
    }
    
    descriptionTextView.text = descritionText
    categoryLabel.text = categoryName
    
    latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
    longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
    
    if let placemark = placemark {
      addressLabel.text = stringFromPlacemark(placemark)
    } else {
      addressLabel.text = "No Address Found"
    }
    
    dateLabel.text = formatDate(date)

    let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
    gestureRecognizer.cancelsTouchesInView = false
    tableView.addGestureRecognizer(gestureRecognizer)
  }
  
  func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
    let point = gestureRecognizer.locationInView(tableView)
    let indexPath = tableView.indexPathForRowAtPoint(point)
    
    if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
      return
    }
    
    descriptionTextView.resignFirstResponder()
  }
  
  func stringFromPlacemark(placemark: CLPlacemark) -> String {
    var text = ""
    
    if let s = placemark.subThoroughfare {
      text += s + " "
    }
    if let s = placemark.thoroughfare {
      text += s + ", "
    }
    if let s = placemark.locality {
      text += s + ", "
    }
    if let s = placemark.administrativeArea {
      text += s + " "
    }
    if let s = placemark.postalCode {
      text += s + ", "
    }
    if let s = placemark.country {
      text += s
    }
    return text
  }

  func formatDate(date: NSDate) -> String {
    return dateFormatter.stringFromDate(date)
  }

  @IBAction func done() {
    let hudView = HudView.hudInView(navigationController!.view, animated: true)
    hudView.text = "Tagged"
    
    
    let location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedObjectContext) as! Location
    
    location.locationDescription = descriptionTextView.text
    location.category = categoryName
    location.latitude = coordinate.latitude
    location.longitude = coordinate.longitude
    location.date = date
    location.placemark = placemark
    
    do{
        try managedObjectContext.save()
    }catch{
        fatalCoreDataError(error)
    }
    
    
    afterDelay(0.6) {
      self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  @IBAction func cancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "PickCategory" {
      let controller = segue.destinationViewController as! CategoryPickerViewController
      controller.selectedCategoryName = categoryName
    }
  }
  
  @IBAction func categoryPickerDidPickCategory(segue: UIStoryboardSegue) {
    let controller = segue.sourceViewController as! CategoryPickerViewController
    categoryName = controller.selectedCategoryName
    categoryLabel.text = categoryName
  }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch (indexPath.section, indexPath.row) {
    case (0, 0):
        return 88
    
    case (1, _):
        return imageView.hidden ? 44 : 280
    case (2, 2):
        addressLabel.frame.size = CGSize(
            width: view.bounds.size.width - 115,
            height: 10000)
        addressLabel.sizeToFit()
        addressLabel.frame.origin.x = view.bounds.size.width -
            addressLabel.frame.size.width - 15
        return addressLabel.frame.size.height + 20
    default:
        return 44
    }
    
    
    }
  
  override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    if indexPath.section == 0 || indexPath.section == 1 {
      return indexPath
    } else {
      return nil
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if indexPath.section == 0 && indexPath.row == 0 {
      descriptionTextView.becomeFirstResponder()
    }
    else if indexPath.section == 1 && indexPath.row == 0 {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        takePhotoWithCamera()
    }
  }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)
        let takePhotoAction = UIAlertAction(title: "Take Photo",
                                            style: .Default, handler: {_ in self.takePhotoWithCamera()})
        alertController.addAction(takePhotoAction)
        let chooseFromLibraryAction = UIAlertAction(title:
            "Choose From Library", style: .Default, handler: {_ in self.choosePhotoFromLibrary()})
        alertController.addAction(chooseFromLibraryAction)
        presentViewController(alertController, animated: true,
                              completion: nil)
    }
    
    deinit{
        
        print("*** deinit \(self)")
        NSNotificationCenter.defaultCenter().removeObserver(observer!)
        
    }

    
}

//we are creating extension here as it allows us to group all
//photo picking code together.

extension LocationDetailsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{


    func takePhotoWithCamera(){
    
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    presentViewController(imagePicker, animated: true, completion: nil)
    
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        if let image = image{
        
            showImage(image)
        }
        
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func listenForBackgroundNotification() {
       observer = NSNotificationCenter.defaultCenter().addObserverForName(
            UIApplicationDidEnterBackgroundNotification, object: nil,
            queue: NSOperationQueue.mainQueue()) { [weak self]_ in
                if let strongSelf = self{
                if strongSelf.presentedViewController != nil {
                    strongSelf.dismissViewControllerAnimated(false, completion: nil)
                }
                strongSelf.descriptionTextView.resignFirstResponder()
                }
        }
    }
}

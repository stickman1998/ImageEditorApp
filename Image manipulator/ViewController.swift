//
//  ViewController.swift
//  Image manipulator
//
//  Created by Lee Bachman on 5/27/17.
//  Copyright © 2017 LeviLevi. All rights reserved.
//

    import UIKit
    import CoreImage

    class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UIScrollViewDelegate {
        
        var redRGBA = RGBAImage?()
        var greenRGBA = RGBAImage?()
        var blueRGBA = RGBAImage?()
        var YellowResult = CIImage?()
        var YellowUI = UIImage?()
        var purpleRGBA = RGBAImage?()
        var img = RGBAImage?()
        var avgRed = Int?()
        var avgGreen = Int?()
        var avgBlue = Int?()
        var avgFullSpectrum = Int?()
        let redMultiplier = Int(2)
        let greenMultiplier = Int(2)
        let blueMultiplier = Int(2)
        var value = Int?(0)
        var imgSelected = Bool()
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet var filterMenu: UIView!
        @IBOutlet weak var buttonView: UIView!
        @IBOutlet weak var filterButton: UIButton!
        @IBOutlet weak var compareButton: UIButton!
        @IBOutlet var loadingImage: UIView!
        @IBOutlet weak var activityIndicator1: UIActivityIndicatorView!
        @IBOutlet weak var scrollView: UIScrollView!
        @IBOutlet var zoomTapRecognizer: UITapGestureRecognizer!
        
        func convert(cmage:CIImage) -> UIImage
        {
            let context:CIContext = CIContext.init(options: nil)
            let cgImage:CGImage = context.createCGImage(cmage, fromRect: cmage.extent)
            let image:UIImage = UIImage.init(CGImage: cgImage)
            return image
        }
        
        func imageWasSelected(){
            img = RGBAImage(image: (imageView.image)!)
            let x = img?.width
            let y = img?.height
            let index = ((x)! * (y)!) - 1
            var totalRed = Int()
            var totalGreen = Int()
            var totalBlue = Int()
            for _ in 0..<img!.height{
                for _ in 0..<img!.width{
                    let index = ((img?.width)! * (img?.height)!) - 1
                    var pixel = img!.pixels[Int(index)]
                    
                    totalRed += Int(pixel.red)
                    totalGreen += Int(pixel.green)
                    totalBlue += Int(pixel.blue)
                }
            }
            avgRed = totalRed/index
            avgGreen = totalGreen/index
            avgBlue = totalBlue/index
            avgFullSpectrum = (avgRed! + avgBlue! + avgGreen!) / 3
            
            imgSelected = true
        }
        func hasImageBeenSelected(){
            if imgSelected == false {
                imageWasSelected()
            }
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            filterMenu.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
            
              zoomTapRecognizer.numberOfTapsRequired = 2
                scrollView.zoomScale = 0.5
                hideLoadingScreen()
                nilImages()
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        @IBOutlet weak var redButton: UIButton!
        @IBOutlet weak var greenButton: UIButton!
        @IBOutlet weak var purpleButton: UIButton!
        @IBOutlet weak var yellowButton: UIButton!
        @IBOutlet weak var blueButton: UIButton!
        
        func nilImages () {
            redRGBA = nil
            greenRGBA = nil
            blueRGBA = nil
            YellowResult = nil
            purpleRGBA = nil
        }
        
        @IBAction func onCompare(sender: UIButton) {
            
        }

        
        
        
        @IBAction internal func redFilter(sender: UIButton) {
            hasImageBeenSelected()
            if (sender.selected) {
                imageView.image = img?.toUIImage()
                sender.selected = false
            }else {
                if redRGBA == nil {
                    redRGBA = img
                    for x in 0..<redRGBA!.width{
                        for y in 0..<redRGBA!.height{
                            let index = y * (redRGBA?.width)! + x
                            var pixel = redRGBA!.pixels[index]
                            let redDiff = Int(pixel.red) - avgRed!
                            let greenDiff = Int(pixel.green) - avgGreen!
                            let blueDiff = Int(pixel.blue) - avgBlue!
                            
/*                            if redDiff > (greenDiff) && redDiff > (blueDiff) {
                                pixel.red = UInt8(max(0, min(255, avgFullSpectrum! + redDiff * redMultiplier)))
                                redRGBA?.pixels[index] = pixel
                            }
 */
                            if redDiff > 0 {
                                pixel.red = UInt8(max(0, min(255, avgFullSpectrum! + redDiff * redMultiplier)))
                                redRGBA?.pixels[index] = pixel
                            }
                    }
                }
                }

                    
                
                imageView.image = redRGBA?.toUIImage()
                unselectFilterButtons()
                sender.selected = true
                }
            
        }
        
        
        @IBAction func greenFilter(sender: UIButton) {
            hasImageBeenSelected()
            if (sender.selected) {
            imageView.image = img?.toUIImage()
                sender.selected = false
            }else {
                
                if greenRGBA == nil {
                    greenRGBA = img
                    for x in 0..<greenRGBA!.width{
                        for y in 0..<greenRGBA!.height{
                            let index = y * (greenRGBA?.width)! + x
                            var pixel = greenRGBA!.pixels[index]
                            let redDiff = Int(pixel.red) - avgRed!
                            let greenDiff = Int(pixel.green) - avgGreen!
                            let blueDiff = Int(pixel.blue) - avgBlue!
                            
                            if greenDiff > redDiff + 15 && greenDiff > blueDiff + 15 {
                                pixel.green = UInt8(max(0, min(180, avgGreen! + greenDiff * greenMultiplier)))
                                greenRGBA?.pixels[index] = pixel
                            }
                        }
                    }
                }
                
                imageView.image = greenRGBA?.toUIImage()
                unselectFilterButtons()
                sender.selected = true
            }
        }
        
        @IBAction func blueFilter(sender: UIButton) {
            hasImageBeenSelected()
            if (sender.selected) {
                imageView.image = img?.toUIImage()
                sender.selected = false
            }else {
                if blueRGBA == nil {
                    blueRGBA = img
                    for x in 0..<blueRGBA!.width{
                        for y in 0..<blueRGBA!.height{
                            let index = y * (blueRGBA?.width)! + x
                            var pixel = blueRGBA!.pixels[index]
                            let redDiff = Int(pixel.red) - avgRed!
                            let greenDiff = Int(pixel.green) - avgGreen!
                            let blueDiff = Int(pixel.blue) - avgBlue!
                            
                            if  blueDiff > (redDiff) && blueDiff > (greenDiff){
                                pixel.blue = UInt8(max(0, min(180, avgBlue! + blueDiff * blueMultiplier)))
                                blueRGBA?.pixels[index] = pixel
                            }
                        }
                    }
                }
                
                imageView.image = blueRGBA?.toUIImage()
                unselectFilterButtons()
                sender.selected = true
            }

        }
        
        @IBAction func yellowFilter(sender: UIButton) {
            hasImageBeenSelected()
            if (sender.selected) {
                imageView.image = img?.toUIImage()
                sender.selected = false
            }else {
                if YellowResult == nil {
                    print("Yeah")
                    let filter = CIFilter(name: "CISepiaTone")!                         // 2
                    filter.setValue(0.8, forKey: kCIInputIntensityKey)
                    let image = CIImage(image: imageView.image!)                           // 3
                    filter.setValue(image, forKey: kCIInputImageKey)
                    YellowResult = filter.outputImage!
                    YellowUI = convert(YellowResult!)
                }
                imageView.image = YellowUI
                unselectFilterButtons()
                sender.selected = true
            }
        }
        @IBAction func purpleFilter(sender: UIButton) {
            hasImageBeenSelected()
            if (sender.selected) {
                imageView.image = img?.toUIImage()
                sender.selected = false
            }else {
            if purpleRGBA == nil {
                purpleRGBA = img
                for x in 0..<purpleRGBA!.width{
                    for y in 0..<purpleRGBA!.height{
                        let index = y * (purpleRGBA?.width)! + x
                        var pixel = purpleRGBA!.pixels[index]
                        let redDiff = Int(pixel.red) - avgRed!
                        let greenDiff = Int(pixel.green) - avgGreen!
                        let blueDiff = Int(pixel.blue) - avgBlue!
                        
                        if redDiff > 0 {
                            if redDiff > (greenDiff - 40) && redDiff > (blueDiff - 40) {
                                pixel.red = UInt8(max(0, min(180, avgRed! + redDiff * redMultiplier)))
                                purpleRGBA?.pixels[index] = pixel
                            }
                        }
                    }
                }
                let placeholderImage = purpleRGBA?.toUIImage()
                purpleRGBA = RGBAImage(image: placeholderImage!)
                for x in 0..<purpleRGBA!.width{
                    for y in 0..<purpleRGBA!.height{
                        let index = y * (purpleRGBA?.width)! + x
                        var pixel = purpleRGBA!.pixels[index]
                        let redDiff = Int(pixel.red) - avgRed!
                        let greenDiff = Int(pixel.green) - avgGreen!
                        let blueDiff = Int(pixel.blue) - avgBlue!

                        
                        if blueDiff > (redDiff - 40) && blueDiff > (greenDiff - 40) {
                            if blueDiff > 0 {
                                pixel.blue = UInt8(max(0, min(180, avgBlue! + blueDiff * blueMultiplier)))
                                purpleRGBA?.pixels[index] = pixel
                            }
                        }
                    }
                }
                }
                imageView.image = purpleRGBA?.toUIImage()
                unselectFilterButtons()
                sender.selected = true
            }
        }
        
        @IBAction func onShare(sender: AnyObject) {
            let activityController = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: nil)
            presentViewController(activityController, animated: true, completion: nil)
        }
        
        @IBAction func onNewPhoto(sender: UIButton) {
            let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: {
                peewee in
                self.showCamera()
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: {
                peewee in
                self.showAlbum()
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
        }
        
        
        
        func showCamera(){
            let cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.sourceType = .Camera
            self.presentViewController(cameraPicker, animated: true, completion: nil)
        }
        
        func showAlbum(){
            let albumPicker = UIImagePickerController()
            albumPicker.delegate = self
            albumPicker.sourceType = .PhotoLibrary
            self.presentViewController(albumPicker, animated: true, completion: nil)
            
        }
        
        func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            dismissViewControllerAnimated(true, completion: viewDidLoad)
            
            if let new = info[UIImagePickerControllerOriginalImage] as? UIImage {
                addLoadingScreen()
                imageView.image = new
                unselectFilterButtons()
                img = RGBAImage(image: imageView.image!)
            }
        }
        
        func imagePickerControllerDidCancel(picker: UIImagePickerController) {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        func addLoadingScreen (){
            view.addSubview(loadingImage)
            loadingImage.translatesAutoresizingMaskIntoConstraints = false
            
            let bottomConstraint = loadingImage.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor)
            let rightConstraint = loadingImage.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
            let leftConstraint = loadingImage.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
            let topConstraint = loadingImage.topAnchor.constraintEqualToAnchor(view.topAnchor)
            
            NSLayoutConstraint.activateConstraints([bottomConstraint,rightConstraint,leftConstraint,topConstraint])
            
            activityIndicator1.startAnimating()
            
            view.layoutIfNeeded()
        }
        
        func hideLoadingScreen () {
            self.loadingImage.removeFromSuperview()
        }
        
        @IBAction func onFilter(sender: UIButton) {
            if (sender.selected){
                hideFilterMenu()
                filterButton.selected = false
            }else{
                addFilterMenu()
                filterButton.selected = true
            }
                    }
        func addFilterMenu (){
            view.addSubview(filterMenu)
            
            filterMenu.translatesAutoresizingMaskIntoConstraints = false
            
            let bottomConstraint = filterMenu.bottomAnchor.constraintEqualToAnchor(buttonView.topAnchor)
            let rightConstraint = filterMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
            let leftConstraint = filterMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
            let heightConstraint = filterMenu.heightAnchor.constraintEqualToConstant(44)
            
            NSLayoutConstraint.activateConstraints([bottomConstraint,rightConstraint,leftConstraint,heightConstraint])
            
            view.layoutIfNeeded()
            
            UIView.animateWithDuration(0.4) {
                self.filterMenu.alpha = 1.0
            }

        }
        
        func hideFilterMenu () {
            imageView.image = img?.toUIImage()
            unselectFilterButtons()
            UIView.animateWithDuration(0.4, animations:  {
                self.filterMenu.alpha = 0
            }) { vulpe in
            self.filterMenu.removeFromSuperview()
            }
        }
        
        func unselectFilterButtons(){
            redButton.selected = false
            greenButton.selected = false
            blueButton.selected = false
            purpleButton.selected = false
            yellowButton.selected = false
        }
        func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
            return imageView
        }
        @IBAction func onTap(sender: UITapGestureRecognizer) {
            switch scrollView.zoomScale {
            case 0 :
                scrollView.zoomScale = scrollView.zoomScale + 1.5
            default:
                if scrollView.zoomScale > 3 {
                    scrollView.zoomScale = scrollView.zoomScale - 1.5
                }else {
                scrollView.zoomScale = scrollView.zoomScale + 0.5
                }
            }
        }
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
        }
}















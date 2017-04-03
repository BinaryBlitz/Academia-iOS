import UIKit

//ZPPOnboardingVCID

class ZPPOnboardingVC: UIViewController {

  let resoreIdentifier: String = "ZPPOnboardingVCID"

  var text, backName, iphoneName: String?;

  @IBOutlet weak var backgroundImageView: UIImageView!

  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var iphoneImageView: UIImageView!

  var shouldShowDescriptionPreview: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.gray

    let font = UIFont(name: "Roboto-Black", size: 24)
    let attribs = [
      NSForegroundColorAttributeName: UIColor.white,
      NSStrokeColorAttributeName: UIColor.black,
      NSFontAttributeName: font ?? UIFont.systemFont(ofSize: 24),
      NSStrokeWidthAttributeName: 1.0
    ] as [String : Any]

    let attributedText = NSAttributedString(string: "\(text)", attributes: attribs)
    textLabel.attributedText = attributedText

    let backImg = UIImage(named: backName!)

    if let bi = backImg {
      backgroundImageView.image = bi
    }


    let iphoneImg = UIImage(named: iphoneName!)

    if let ii = iphoneImg {
      iphoneImageView.image = ii
    }


    let s = UIScreen.main.bounds.size;
    if s.height / s.width < 16 / 9.0 {
      textLabel.font = textLabel.font.withSize(22)
    }
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func configure(_ backName: String, iphoneName: String, text: String) {

    self.backName = backName
    self.text = text
    self.iphoneName = iphoneName

  }


  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}

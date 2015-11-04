import UIKit
import Cartography

class TableViewCell: UITableViewCell {
    var label: UILabel?
    var toggle: UISwitch?
    var enabled: Bool?
    var sound: Sound?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.enabled = false
        self.sound = Sound()
        
        self.toggle = UISwitch(frame: CGRectZero)
        self.toggle!.on = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        
        
        self.setNeedsUpdateConstraints()
    }

    
    func switchValueDidChange(sender:UISwitch!){
        if (sender.on == true){
            self.enabled = true;
            print("button-on \(self.enabled)")
        }
        else{
            self.enabled = false;
            print("button-off \(self.enabled)")
        }
    }
}
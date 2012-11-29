class Color < MotionResource::Base
  attr_accessor :hex
  
  has_many :tags
  
  scope :random, :url => 'json/colors/random/7'
  
  def ui_color
    pointer = Pointer.new(:uint)
    scanner = NSScanner.scannerWithString(self.hex)
    scanner.scanHexInt(pointer)
    rgbValue = pointer[0]
    return UIColor.colorWithRed(((rgbValue & 0xFF0000) >> 16)/255.0, green:((rgbValue & 0xFF00) >> 8)/255.0, blue:(rgbValue & 0xFF)/255.0, alpha:1.0)
  end
end

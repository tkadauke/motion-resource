class MainNavigationController < UINavigationController
  def init
    initWithRootViewController(ColorViewController.alloc.init)
    self
  end
end

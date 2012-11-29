class ColorViewController < UITableViewController
  attr_accessor :colors
  
  def init
    self.colors = []
    self.title = "7 random colors"
    super
  end
  
  def viewDidLoad
    load_data
    super
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.colors.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    color = colors[indexPath.row]
    cell.textLabel.text = color.hex
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end
  
  def tableView(tableView, willDisplayCell:cell, forRowAtIndexPath:indexPath)
    color = colors[indexPath.row]
    cell.backgroundColor = color.ui_color
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    navigationController.pushViewController(TagsViewController.alloc.initWithColor(colors[indexPath.row]), animated:true)
  end
  
  def load_data
    Color.random do |results|
      if results
        self.colors = results
      end
      tableView.reloadData
    end
  end
end

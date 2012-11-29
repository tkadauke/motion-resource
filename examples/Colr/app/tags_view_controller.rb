class TagsViewController < UITableViewController
  attr_accessor :color
  
  def initWithColor(color)
    self.color = color
    self.title = "Tags for color #{color.hex}"
    init
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    self.color.tags.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier('Cell')
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:'Cell')
    
    tag = color.tags[indexPath.row]
    cell.textLabel.text = tag.name
    cell.selectionStyle = UITableViewCellSelectionStyleNone
    cell
  end
end

class WorkItem < ActiveRecord::Base
  def update_self( column, value )
    case column
    when "category"
      self.category = value
    when "title"
      self.title = value
    when "date"
      self.date = value
    when "role"
      self.role = value
    when "link"
      self.link = value
    end
  end
end
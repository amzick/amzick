class DropBodyAttributeFromWorkItemsTable < ActiveRecord::Migration
  def up
    remove_column :workitems, :body
  end

  def down
    add_column :workitems, :body
  end
end

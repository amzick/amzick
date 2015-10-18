class ChangeWorkItemsTableName < ActiveRecord::Migration
  def self.up
    rename_table :workitems, :work_items
  end

  def self.down
    rename_table :work_items, :workitems
  end
end

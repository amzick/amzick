class AddLinkColumnToWorkItemsTable < ActiveRecord::Migration
  def up
    add_column :work_items, :link, :string
  end

  def down
    remove_column :work_items, :link, :string
  end
end

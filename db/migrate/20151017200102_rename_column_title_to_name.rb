class RenameColumnTitleToName < ActiveRecord::Migration
  def change
    rename_column :fields, :title, :name
  end
end

class RenameTablePagesToFields < ActiveRecord::Migration
  def change
    rename_table :pages, :fields
  end
end

class CreateWorkItemTable < ActiveRecord::Migration
  def self.up
    create_table :workitems do |t|
      t.string :category
      t.string :title
      t.string :date
      t.string :role
      t.text   :body
      t.timestamps
    end
  end

  def self.down
    drop_table :workitems
  end
end

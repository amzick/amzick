class CreateField < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.string :section
      t.string :title
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :fields
  end
end

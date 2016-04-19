class AddingCodetoUsers < ActiveRecord::Migration
  def change
    add_column :users, :number_of_lines, :integer
    add_column :users, :number_of_projects, :integer
  end
end

class AddingLogotoJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :logo, :string
  end
end

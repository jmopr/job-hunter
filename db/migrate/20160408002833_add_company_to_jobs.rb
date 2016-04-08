class AddCompanyToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :company, :string
  end
end

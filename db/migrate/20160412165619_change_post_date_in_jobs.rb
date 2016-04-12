class ChangePostDateInJobs < ActiveRecord::Migration
  def change
    change_column :jobs, :post_date, :string
  end
end

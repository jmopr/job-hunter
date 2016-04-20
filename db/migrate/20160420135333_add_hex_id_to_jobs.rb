class AddHexIdToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :hex_id, :string
  end
end

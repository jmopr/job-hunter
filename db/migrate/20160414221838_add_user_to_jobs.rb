class AddUserToJobs < ActiveRecord::Migration
  def change
    add_reference :jobs, :user, index: true, foreign_key: true
  end
end

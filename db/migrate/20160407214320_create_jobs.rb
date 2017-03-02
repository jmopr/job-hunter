class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.date :post_date
      t.text :description
      t.boolean :applied

      t.timestamps null: false
    end
  end
end

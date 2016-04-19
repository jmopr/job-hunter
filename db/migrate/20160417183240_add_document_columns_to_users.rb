class AddDocumentColumnsToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :document
  end
end

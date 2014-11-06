class AddUserIdToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :user, index: true, null: false
  end
end

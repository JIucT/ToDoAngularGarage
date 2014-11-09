class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :task, index: true, null: false
      t.string :text, null: false

      t.timestamps
    end
  end
end

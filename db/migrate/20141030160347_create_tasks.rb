class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.references :project, index: true, null: false
      t.integer :priority, null: false, default: 0
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end

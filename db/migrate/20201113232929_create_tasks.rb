class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false, default: ""
      t.boolean :status, default: false
      t.integer :priority, null: false, default: 0
      t.datetime :deadline
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end

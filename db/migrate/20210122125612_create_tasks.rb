class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :body
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end

class AddDueTimeToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :due_time, :datetime
  end
end

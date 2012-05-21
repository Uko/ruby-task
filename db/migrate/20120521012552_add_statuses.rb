class AddStatuses < ActiveRecord::Migration
  
	STATUSES = [
    {:name => 'Waiting for Staff Response'},
    {:name => 'Waiting for Customer'},
    {:name => 'On Hold'},
    {:name => 'Cancelled'},
    {:name => 'Completed'}
  ]

	def up
		STATUSES.each do |status|
			Status.create!(status)
		end
  end

  def down
		STATUSES.each do |status|
      Status.find_by_name(status[:name]).destroy if Status.exists? :name => status[:name]
    end
  end
end

class AddAuthorToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :author, :string

		Reply.reset_column_information
		Reply.all.each do |reply|
			reply.author = "Anonimus"
		  reply.save!
		end
  end
end

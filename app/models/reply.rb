class Reply < ActiveRecord::Base
  belongs_to :ticket
  attr_accessible :text, :changes, :author

	validates :text, :author, :presence => true
end

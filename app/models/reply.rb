class Reply < ActiveRecord::Base
  belongs_to :ticket
  attr_accessible :text, :changes

	validates :text, :presence => true
end

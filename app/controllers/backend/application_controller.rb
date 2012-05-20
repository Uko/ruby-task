class Backend::ApplicationController < ApplicationController
	
	before_filter :authenticate
	
end

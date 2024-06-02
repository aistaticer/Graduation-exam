class Admin::CommentsController < ApplicationController
	def index
		@users = User.with_attached_thumbnail.all
	end
end

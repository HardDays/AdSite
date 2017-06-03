class AuthorizeController < ApplicationController
	def self.authorize(request)
		@tokenstr = request.headers['Authorization']
		@token = Token.find_by token: @tokenstr

		if @token == nil
			return nil
		end

		if not @token.is_valid?
			@token.destroy
			return nil
		end
		return @token.user
	end
end

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

	def self.authorize(request, access)
		@user = authorize(request)
		return @user != nil and @user.has_access?(access)
	end

	def self.authorize(request, access, user)
		@user = authorize(request)
		return @user != nil and (@user.has_access?(access) or user == @user)
	end
end

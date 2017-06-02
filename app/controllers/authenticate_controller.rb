require 'digest'
require 'securerandom'

class AuthenticateController < ApplicationController
	before_action :skip_session

	def skip_session
	    request.session_options[:skip] = true
	end

	def process_token(request, user)
		@info = Digest::SHA256.hexdigest(request.ip + request.user_agent + 'kek salt')
		@token = @user.tokens.find{|s| s.info == @info}
		if @token != nil
			@token.destroy
		end
	end

	def login
		@password = User.encrypt_password(params[:password])
		@user = User.find_by email: params[:email], password: @password
		if @user != nil
			process_token(request, @user)
			@token = Token.new(user_id: @user.id, info: @info)
			@token.save
			render json: {token: @token.token} , status: :ok
		else
			render status: :unauthorized
		end
	end

	def logout
		@token = Token.find_by token: params[:token]
		if @token != nil
			@token.destroy
			render status: :ok
		else
			render status: :bad_request
		end
	end
end

class AccessController < ApplicationController

	before_action :authorize_grant, only: [:grant_admin_access_route]
	before_action :authorize_view, only: [:user_access]
	before_action :authorize_self, only: [:my_access]

	def grant_admin_access_route
		@user = find(params[:user_id])
		if self.grant_admin_access(@user)
			render status: :ok
		else
			render status: :bad_request
		end
	end

	def user_access
		get_access
	end

	def my_access
		get_access
	end

	def self.grant_access(user, access_list)
		user.accesses.clear
		access_list.each do |acc|
			begin
				@acc = Access.find_by name: acc
				user.accesses << @acc
			rescue Exception
				return false
			end
		end
		return true
	end

	def self.grant_admin_access(user)
		@accesses = [:can_create_ads, :can_view_ads, :can_delete_ads, :can_update_ads,
					:can_create_users, :can_view_users, :can_delete_users, :can_update_users,
					:can_create_user_access, :can_view_user_access, :can_delete_user_access, :can_update_user_access,
					:can_rate]
		return grant_access(user, @accesses)
	end

	def self.grant_client_access(user)
		@accesses = [:can_view_ads, :can_rate]
		return grant_access(user, @accesses)
	end

	def self.grant_enterprises_access(user)
		@accesses = [:can_create_ads, :can_view_ads, :can_rate]
		return grant_access(user, @accesses)
	end

	private

	def get_access
		if @user != nil
			render json: @user.accesses.collect{|a| a.name}, status: :ok
		else
			render status: :unauthorized
		end
	end

	def authorize_grant
    	if not AuthorizeController.authorize_access(request, :can_create_user_access)
   			render status: :unauthorized
  		end
    end

    def authorize_view
    	@user = User.find(params[:id])
    	if not AuthorizeController.authorize_self(request, :can_view_user_access, @user)
   			render status: :unauthorized
  		end
    end

    def authorize_self
    	@user = AuthorizeController.authorize(request)
    end

end

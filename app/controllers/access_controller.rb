class AccessController < ApplicationController

	before_action :authorize_grant, only: [:grant_admin_access_route]

	def grant_admin_access_route
		@user = find(params[:user_id])
		if self.grant_admin_access(@user)
			render status: :ok
		else
			render status: :bad_request
		end
	end

	def self.grant_access(user, access_list)
		@res = true
		access_list.each do |acc|
			begin
				@acc = Access.find_by name: acc
				@res = @res and user.accesses << @acc
			rescue Exception
			end
		end
		return @res
	end

	def self.grant_admin_access(user)
		@accesses = [:can_create_ads, :can_view_ads, :can_delete_ads, :can_update_ads,
					:can_create_users, :can_view_users, :can_delete_users, :can_update_users,
					:can_create_user_access, :can_view_user_access, :can_delete_user_access, :can_update_user_access]
		return grant_access(user, @accesses)
	end

	def self.grant_client_access(user)
		@accesses = [:can_view_ads]
		return grant_access(user, @accesses)
	end

	def self.grant_enterprises_access(user)
		@accesses = [:can_create_ads, :can_view_ads]
		return grant_access(user, @accesses)
	end

	def authorize_grant
      @from_user = AuthorizeController.authorize(request)
      if @from_user == nil or not @from_user.has_access?(:can_create_user_access)
        render status: :unauthorized
      end
    end

end

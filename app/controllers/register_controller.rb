class RegisterController < ApplicationController

	#TODO: refactor
	def create
		#create user
		@user = User.new(user_params)
		if !@user.save
			render json: @user.errors, status: :unprocessable_entity and return
		end

		if params[:company] != nil
			#create company
			@company = Company.new(company_params)
			@company.user_id = @user.id
			#add category
			if params[:sub_category] != nil
				@company.sub_category = SubCategory.find_by name: params[:sub_category]
			end
			#add type
			if params[:c_type] != nil
				@company.c_type = CType.find_by name: params[:c_type]
			end
			#create company
			@ok = true
			if !@company.save
				@user.destroy
				render json: @company.errors, status: :unprocessable_entity and return
			end
			#many-to-many agrements
			if params[:agrements] != nil
				@ok = @ok and AgrementController.set_agrements(@company, params[:agrements])
			end
			#many-to-many expretises
			if params[:expertises] != nil
				@ok = @ok and ExpertiseController.set_expertises(@company, params[:expertises])
			end
			#grant access to post ads
			@ok = @ok and AccessController.grant_enterprises_access(@user)
			#check error
			if not @ok
				@user.destroy
				@company.destroy
				render status: :unprocessable_entity and return
			else
				render json: @user, except: :password, status: :created, location: @user
			end
		else
			#give client access
			if not AccessController.grant_client_access(@user)
				@user.destroy
				render status: :unprocessable_entity and return
			end
			render json: @user, except: :password, status: :created, location: @user
		end 
	end

	def update
		@user = User.find(params[:user][:id])
		@company = Company.find(params[:company][:id])
		#update user
		if !@user.update(user_params)
			render json: @user.errors, status: :unprocessable_entity and return
    	end
    	#update company
    	if !@company.update(company_params)
    		render json: @company.errors, status: :unprocessable_entity and return
    	end
    	render json: @user, except: :password, status: :updated
	end

	def get
		@user = User.find(params[:id])
    	render json: @user, except: :password
  	end

  	def get_all
		@users = User.all
    	render json: @users, except: :password
  	end

	def user_params
		params.require(:user).permit(:email, :password, :first_name, :last_name, :phone)
	end

	def company_params
		params.require(:company).permit(:name, :logo, :address, :other_address, :email, :phone, :opening_times, :c_type, :company_id, :description, :links, :user_id)
	end
end

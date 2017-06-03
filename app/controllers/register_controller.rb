class RegisterController < ApplicationController

	#TODO: refactor
	def register
		@user = User.new(user_params)
		if !@user.save
			render json: @user.errors, status: :unprocessable_entity and return
		end

		if params[:company] != nil
			@company = Company.new(company_params)
			@company.user_id = @user.id
			@company.sub_category = SubCategory.find_by name: params[:sub_category]

			if !@company.save
				@user.destroy
				render json: @company.errors, status: :unprocessable_entity and return
			end

			if params[:agrements] != nil
				if not AgrementController.set_agrements(@company, params[:agrements])
					@user.destroy
					@company.destroy
					render status: :unprocessable_entity and return
				end
			end

			if params[:expertises] != nil
				if not ExpertiseController.set_expertises(@company, params[:expertises])
					@user.destroy
					@company.destroy
					render status: :unprocessable_entity and return
				end
			end

			if not AccessController.grant_enterprises_access(@user)
				@user.destroy
				@company.destroy
				render status: :unprocessable_entity and return
			end

			render json: {user: @user, company: @company}, except: :password, status: :created, location: @user
		else
			if not AccessController.grant_client_access(@user)
				@user.destroy
				render status: :unprocessable_entity and return
			end
			render json: @user, except: :password, status: :created, location: @user
		end 
	end

	def user_params
		params.require(:user).permit(:email, :password, :first_name, :last_name, :phone)
	end

	def company_params
		params.require(:company).permit(:name, :logo, :address, :other_address, :email, :phone, :opening_times, :type, :company_id, :description, :links, :user_id)
	end
end

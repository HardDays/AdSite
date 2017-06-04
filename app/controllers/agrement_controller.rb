class AgrementController < ApplicationController

	def self.set_ad_agrements(ad, agrements)
		ad.agrements.clear
		agrements.each do |agr|
			begin
				ad.agrements << agr
			rescue Exception
				return false
			end
		end
	end

	def self.set_company_agrements(company, agrements)
		company.agrements.clear
		agrements.each do |agr|
			begin
				@agr = Agrement.find_by name: agr
				company.agrements << @agr
			rescue Exception
				return false
			end
		end
		return true
	end
end

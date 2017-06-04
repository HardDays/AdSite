class ExpertiseController < ApplicationController

	def self.set_ad_expertises(ad, expertises)
		ad.expertises.clear
		expertises.each do |exp|
			begin
				ad.expertises << exp
			rescue Exception
				return false
			end
		end
		return true
	end


	def self.set_company_expertises(company, expertises)
		company.expertises.clear
		expertises.each do |exp|
			begin
				@exp = Expertise.find_by name: exp
				company.expertises << @exp
			rescue Exception
				return false
			end
		end
		return true
	end
end

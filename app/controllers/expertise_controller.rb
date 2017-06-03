class ExpertiseController < ApplicationController
	def self.set_expertises(company, expertises)
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

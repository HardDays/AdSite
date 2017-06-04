class AgrementController < ApplicationController

	def self.set_agrements(company, agrements)
    #trash2
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

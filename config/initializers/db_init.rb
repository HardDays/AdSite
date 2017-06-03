@access_names = [:can_create_ads, :can_view_ads, :can_delete_ads, :can_update_ads,
				:can_create_users, :can_view_users, :can_delete_users, :can_update_users,
				:can_create_user_access, :can_view_user_access, :can_delete_user_access, :can_update_user_access,
				:can_create_companies, :can_view_companies, :can_delete_companies, :can_update_companies]

@access_names.each do |name|
	@acc = Access.new(name: name)
	@acc.save
end

@sub_categories = [:classique, :e_brooker, :fintech, :crowdfunding, :lendfunding, :institutionnels]

@sub_categories.each do |name|
	@cat = SubCategory.new(name: name)
	@cat.save
end

@expertises = [:credit, :retraite, :placement, :allocation, :epargne, :investissement, 
			  :defiscalisation, :immobilier, :assurance, :investissement_plaisir]

@expertises.each do |name|
	@exp = Expertise.new(name: name)
	@exp.save
end

@agrements = [:CJA, :CIF, :Courtier, :IOSB, :Carte_T]

@agrements.each do |name|
	@agr = Agrement.new(name: name)
	@agr.save
end

@admin = User.new(email: :admin, password: :admin)
@admin.save

@admin = User.find_by email: :admin
AccessController.grant_admin_access(@admin)


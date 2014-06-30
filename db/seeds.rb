# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Account.create(id: 1, company_name: 'EdgeRocket, Inc.', 
	options: '{"budget_management":true,"survey":true,"discussions":"gplus","recommendations":true,"dashboard_demo":true}',
	overview: 'EdgeRocket ecnourages employees to take as many classes as possible')
Account.create(id: 2, company_name: 'TechCorp', 
	options: '{"budget_management":true,"survey":false,"discussions":"builtin","recommendations":true,"dashboard_demo":true}',
	overview: 'TechCorp will reimburse you for up to $200 of online courses per calendar year, subject to your manager’s approval. Questions about EdgeRocket usage can be addressed to your manager, or to Linda Kim in HR.') 
Account.create(id: 3, company_name: 'TrackVia', 
	options: '{"budget_management":false,"survey":false,"discussions":"gplus","recommendations":false,"disable_search":true,"disable_plans":true,"dashboard_demo":false}',
	overview: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sed dapibus erat. Pellentesque at elementum massa. Praesent aliquam, ligula ut tempus venenatis, est purus sagittis lectus, vel cursus risus elit in ligula. In placerat mollis diam, sit amet accumsan massa egestas id. Mauris posuere dapibus metus quis vestibulum. Maecenas varius diam velit, fermentum porta risus placerat dictum') 

# Vendors should be populated by DBA/developers
Vendor.create(id: 1, name: 'Coursera', logo_file_name: 'coursera-logo.png' )
Vendor.create(id: 2, name: 'Youtube', logo_file_name: 'you_tube.png' )
Vendor.create(id: 3, name: 'Udemy', logo_file_name: 'logo_udemy.png' )
Vendor.create(id: 4, name: 'Blog', logo_file_name: 'universal-blog-icon.png' )
Vendor.create(id: 5, name: 'Google Ventures', logo_file_name: 'gv.png' )
Vendor.create(id: 6, name: 'Lynda', logo_file_name: 'lynda_logo2k-d_144x.png' )
Vendor.create(id: 7, name: 'VTC', logo_file_name: 'vtc-logo.png' )
Vendor.create(id: 8, name: 'Skillshare', logo_file_name: 'skillshare-logo-160-20.png' )
Vendor.create(id: 9, name: 'General Assembly', logo_file_name: 'ga-lockup.png' )
Vendor.create(id: 10, name: 'edX', logo_file_name: 'edx-logo-header.png' )
Vendor.create(id: 11, name: 'Code School', logo_file_name: 'code-school-logo-brackets.png' )
Vendor.create(id: 12, name: 'TED', logo_file_name: 'ted-logo.png' )
Vendor.create(id: 13, name: 'HBX', logo_file_name: 'hbx-logo.png' )
Vendor.create(id: 14, name: 'Treehouse', logo_file_name: 'th-logo-white.png' )
Vendor.create(id: 15, name: 'UserZoom', logo_file_name: 'userzoom.png' )
Vendor.create(id: 16, name: 'HubSpot', logo_file_name: 'hubspot.png' )
Vendor.create(id: 17, name: 'Moz' )
Vendor.create(id: 18, name: 'Eduson' )
Vendor.create(id: 19, name: 'Usability Professionals Association', logo_file_name: 'upa.gif' )
Vendor.create(id: 20, name: 'MarketingProfs' )
Vendor.create(id: 21, name: 'AIIM' )
Vendor.create(id: 22, name: 'CBTnuggets' )
Vendor.create(id: 24, name: 'UIE', logo_file_name: 'uie.png' )
Vendor.create(id: 26, name: 'Vimeo', logo_file_name: 'vimeo.png' )

User.create(id: 0, email: 'superadmin@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 1, email: 'admin@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 2, email: 'peter@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 3, email: 'alexey@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 4, email: 'aleksey@dmitriyev.name', password: 'ER0cket!', account_id: 1)
User.create(id: 5, email: 'peter@dmitriyev.name', password: 'ER0cket!', account_id: 1)
User.create(id: 10, email: 'Jane.Smith@TechCorp.com', password: 'TechCorp!', account_id: 2)
User.create(id: 11, email: 'Jose.Calderon@TechCorp.com', password: 'TechCorp!', account_id: 2)
User.create(id: 20, email: 'admin@TrackVia.com', password: 'TrackVia!', account_id: 3)
User.create(id: 21, email: 'employee@TrackVia.com', password: 'TrackVia!', account_id: 3)

Role.create(id: 1, name: 'SA', user_id: 0)
Role.create(id: 2, name: 'Admin', user_id: 1)
Role.create(id: 11, name: 'Admin', user_id: 11)
Role.create(id: 20, name: 'Admin', user_id: 20)


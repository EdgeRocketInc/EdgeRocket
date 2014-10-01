# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Account.destroy_all
Vendor.destroy_all
User.destroy_all
PendingUser.destroy_all
Role.destroy_all
Survey.destroy_all
Skill.destroy_all

account_one = Account.create(company_name: 'EdgeRocket, Inc.',
	options: '{"budget_management":true,"survey":true,"discussions":"gplus","recommendations":true,"dashboard_demo":true}',
	overview: 'EdgeRocket ecnourages employees to take as many classes as possible')
account_two = Account.create(id:2, company_name: 'TechCorp',
	options: '{"budget_management":true,"survey":false,"discussions":"builtin","recommendations":true,"dashboard_demo":true}',
	overview: 'TechCorp will reimburse you for up to $200 of online courses per calendar year, subject to your manager’s approval. Questions about EdgeRocket usage can be addressed to your manager, or to Linda Kim in HR.') 
account_three = Account.create(id:3, company_name: 'TrackVia',
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

Product.create(name: 'Test Product One', authors: 'Seth and Sean', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool')
Product.create(name: 'Test Product Two', authors: 'Sean and Seth', origin: 'Seth and Seans Awesome School', media_type: 'Microfilm', school: 'gSchool')
Product.create(name: 'Test Product Three', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool')

sysop = User.create(email: 'superadmin@edgerocket.co', password: 'ER0cket!', account_id: account_one.id)
admin =User.create(email: 'admin@edgerocket.co', password: 'ER0cket!', account_id: account_one.id)
User.create(email: 'peter@edgerocket.co', password: 'ER0cket!', account_id: account_one.id)
User.create(email: 'alexey@edgerocket.co', password: 'ER0cket!', account_id: account_one.id)
User.create(email: 'aleksey@dmitriyev.name', password: 'ER0cket!', account_id: account_one.id)
User.create(email: 'peter@dmitriyev.name', password: 'ER0cket!', account_id: account_one.id)
User.create(email: 'Jane.Smith@TechCorp.com', password: 'TechCorp!', account_id: account_two.id)
jose = User.create(email: 'Jose.Calderon@TechCorp.com', password: 'TechCorp!', account_id: account_two.id)
admin_track = User.create(email: 'admin@TrackVia.com', password: 'TrackVia!', account_id: account_three.id)
User.create(email: 'employee@TrackVia.com', password: 'TrackVia!', account_id: account_three.id)

PendingUser.new(first_name:"Jimi", last_name: "Hendrix", company_name: "EdgeRocket", email: "jimihendrix@edgerocket.co", encrypted_password: "password", user_type: "Free").save
PendingUser.new(first_name:"Bob", last_name: "Dylan", company_name: "EdgeRocket", email: "bobdylan@edgerocket.co", encrypted_password: "password", user_type: "Enterprise").save


Role.create(id: 0, name: 'Sysop', user_id: sysop.id)
Role.create(id: 2, name: 'Admin', user_id: admin.id)
Role.create(id: 11, name: 'Admin', user_id: jose.id)
Role.create(id: 20, name: 'Admin', user_id: admin_track.id)

Skill.create(name: 'Marketing', key_name: 'marketing', vpos: 0, hpos: 0)
Skill.create(name: 'Social Media Marketing', key_name: 'social_media', vpos: 1, hpos: 0)
Skill.create(name: 'SEO/SEM', key_name: 'seo', vpos: 2, hpos: 0)
Skill.create(name: 'Computer Science', key_name: 'cs', vpos: 3, hpos: 0)
Skill.create(name: 'Computer Networking', key_name: 'computer_networking', vpos: 4, hpos: 0)
Skill.create(name: 'Data Security', key_name: 'data_security', vpos: 5, hpos: 0)
Skill.create(name: 'Data Science', key_name: 'data_science', vpos: 6, hpos: 0)
Skill.create(name: 'Web Development', key_name: 'web_dev', vpos: 7, hpos: 0)

Skill.create(name: 'Database', key_name: 'dbms', vpos: 0, hpos: 1)
Skill.create(name: 'Software Dev. Methodologies', key_name: 'soft_dev_methods', vpos: 1, hpos: 1)
Skill.create(name: 'Management', key_name: 'management', vpos: 2, hpos: 1)
Skill.create(name: 'Leadership', key_name: 'leadership', vpos: 3, hpos: 1)
Skill.create(name: 'Communications', key_name: 'communications', vpos: 4, hpos: 1)
Skill.create(name: 'Sales', key_name: 'sales', vpos: 5, hpos: 1)
Skill.create(name: 'Hiring & Interviewing', key_name: 'hiring', vpos: 6, hpos: 1)
Skill.create(name: 'Effective Presentations', key_name: 'presentations', vpos: 7, hpos: 1)

Skill.create(name: 'Negotiation', key_name: 'negotiation', vpos: 0, hpos: 2)
Skill.create(name: 'Strategy', key_name: 'strategy', vpos: 1, hpos: 2)
Skill.create(name: 'Operations', key_name: 'ops', vpos: 2, hpos: 2)
Skill.create(name: 'Project Management', key_name: 'pmp', vpos: 3, hpos: 2)
Skill.create(name: 'Finance', key_name: 'finance', vpos: 4, hpos: 2)
Skill.create(name: 'UX/UI', key_name: 'ux', vpos: 5, hpos: 2)
Skill.create(name: 'Graphic Design', key_name: 'graphic_design', vpos: 6, hpos: 2)
Skill.create(name: 'Product Management', key_name: 'product_management', vpos: 7, hpos: 2)


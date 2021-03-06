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
Product.destroy_all
Recommendation.destroy_all
MyCourse.destroy_all
Skill.destroy_all

account_one = Account.create(company_name: 'EdgeRocket, Inc.',
	options: '{"budget_management":true,"survey":true,"discussions":"gplus","recommendations":true,"dashboard_demo":true}',
	overview: 'EdgeRocket ecnourages employees to take as many classes as possible',
  disabled: false,
  account_type: 'Free')
account_two = Account.create(company_name: 'TechCorp',
	options: '{"budget_management":true,"survey":false,"discussions":"builtin","recommendations":true,"dashboard_demo":true}',
	overview: 'TechCorp will reimburse you for up to $200 of online courses per calendar year, subject to your manager’s approval. Questions about EdgeRocket usage can be addressed to your manager, or to Linda Kim in HR.',
  disabled: false)
account_three = Account.create(company_name: 'TrackVia',
	options: '{"budget_management":false,"survey":false,"discussions":"gplus","recommendations":false,"disable_search":true,"disable_plans":true,"dashboard_demo":false}',
	overview: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras sed dapibus erat. Pellentesque at elementum massa. Praesent aliquam, ligula ut tempus venenatis, est purus sagittis lectus, vel cursus risus elit in ligula. In placerat mollis diam, sit amet accumsan massa egestas id. Mauris posuere dapibus metus quis vestibulum. Maecenas varius diam velit, fermentum porta risus placerat dictum',
  disabled: false)

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

product = Product.create(name: 'Test Product One', origin: 'Seth and Seans Awesome School', media_type: 'IMAX', school: 'gSchool', vendor_id: 1)
product1 = Product.create(name: 'Test Product Two', authors: 'Sean and Seth', origin: 'Seth and Seans Awesome School', media_type: 'Microfilm', school: 'gSchool', vendor_id: 2)
product2 = Product.create(name: 'Test Product Three', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 3)
product3 = Product.create(name: 'Test Product Four', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 4)
Product.create(name: 'Test Product Five', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 5)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)
Product.create(name: 'Test Product Six', authors: 'Seth and Sean', origin: 'Seth and Seans Radical School', media_type: 'Chalkboard', school: 'gSchool', vendor_id: 6)

sysop = User.create(email: 'superadmin@edgerocket.co', password: 'ER0cket!', account_id: account_one.id, first_name: "Admin", last_name: "Adminington")
admin =User.create(email: 'admin@edgerocket.co', password: 'ER0cket!', account_id: account_one.id, first_name: "John", last_name: "Something")
user1 = User.create(email: 'peter@edgerocket.co', password: 'ER0cket!', account_id: account_one.id, first_name: "Peter", last_name: "Something")
user2 = User.create(email: 'alexey@edgerocket.co', password: 'ER0cket!', account_id: account_one.id, first_name: "Alexey", last_name: "Something")
user3 = User.create(email: 'aleksey@dmitriyev.name', password: 'ER0cket!', account_id: account_one.id, first_name: "Sean", last_name: "Something")
user4 = User.create(email: 'peter@dmitriyev.name', password: 'ER0cket!', account_id: account_one.id, first_name: "Paul", last_name: "Something")
User.create(email: 'Jane.Smith@TechCorp.com', password: 'TechCorp!', account_id: account_two.id)
jose = User.create(email: 'Jose.Calderon@TechCorp.com', password: 'TechCorp!', account_id: account_two.id)
admin_track = User.create(email: 'admin@TrackVia.com', password: 'TrackVia!', account_id: account_three.id)
User.create(email: 'employee@TrackVia.com', password: 'TrackVia!', account_id: account_three.id)

user_count = 0
until user_count == 20
  temp_user = User.create(email: "example#{user_count}@example.name", password: 'ER0cket!', account_id: account_one.id, first_name: "Person#{user_count}", last_name: "Personton")
  MyCourse.create(user_id: temp_user.id, product_id: product1.id, completion_date: Date.today)
  MyCourse.create(user_id: temp_user.id, product_id: product1.id)
  MyCourse.create(user_id: temp_user.id, product_id: product1.id)
  MyCourse.create(user_id: temp_user.id, product_id: product1.id, completion_date: Date.today)
  user_count += 1
end

PendingUser.new(first_name:"Jimi", last_name: "Hendrix", company_name: "EdgeRocket", email: "jimihendrix@edgerocket.co", encrypted_password: "password", user_type: "Free").save
PendingUser.new(first_name:"Bob", last_name: "Dylan", company_name: "EdgeRocket", email: "bobdylan@edgerocket.co", encrypted_password: "password", user_type: "Enterprise").save

Role.create(id: 0, name: 'Sysop', user_id: sysop.id)
Role.create(id: 2, name: 'Admin', user_id: admin.id)
Role.create(id: 11, name: 'Admin', user_id: jose.id)
Role.create(id: 20, name: 'Admin', user_id: admin_track.id)

Skill.create(id: 100, name: 'Communication Skills', key_name: 'communications', image: 'ic_forum_grey600_48dp.png')
Skill.create(id: 101, name: 'Data Science', key_name: 'data_science', image: 'ic_storage_grey600_48dp.png')
Skill.create(id: 102, name: 'Digital Marketing', key_name: 'marketing', image: 'ic_play_shopping_bag_grey600_48dp.png')
Skill.create(id: 103, name: 'Effective Presentations', key_name: 'presentations', image: 'ic_camera_roll_grey600_48dp.png')
Skill.create(id: 104, name: 'Finance', key_name: 'finance', image: 'ic_account_balance_grey600_48dp.png')
Skill.create(id: 105, name: 'Leadership & Management', key_name: 'leadership', image: 'ic_people_grey600_48dp.png')
Skill.create(id: 106, name: 'Operations', key_name: 'ops', image: 'ic_business_grey600_48dp.png')
Skill.create(id: 107, name: 'Project Management', key_name: 'pmp', image: 'ic_assignment_grey600_48dp.png')
Skill.create(id: 108, name: 'Sales', key_name: 'sales', image: 'ic_description_grey600_48dp.png')
Skill.create(id: 109, name: 'Software Engineering', key_name: 'cs', image: 'ic_description_grey600_48dp.png')
Skill.create(id: 110, name: 'UX/UI & Design', key_name: 'ux', image: 'ic_description_grey600_48dp.png')
Skill.create(id: 111, name: 'Web Development', key_name: 'web_dev', image: 'ic_description_grey600_48dp.png')

MyCourse.create(user_id: user1.id, product_id: product1.id)
MyCourse.create(user_id: user1.id, product_id: product1.id, completion_date: Date.today)
MyCourse.create(user_id: user1.id, product_id: product1.id, completion_date: Date.today)
MyCourse.create(user_id: user2.id, product_id: product1.id)
MyCourse.create(user_id: user2.id, product_id: product1.id, completion_date: Date.today)
MyCourse.create(user_id: user2.id, product_id: product1.id)
MyCourse.create(user_id: user3.id, product_id: product1.id, completion_date: Date.today)
MyCourse.create(user_id: user3.id, product_id: product1.id)
MyCourse.create(user_id: user3.id, product_id: product1.id, completion_date: Date.today)

Recommendation.create(product_id: product.id, skill_id: 100)
Recommendation.create(product_id: product1.id, skill_id: 100)
Recommendation.create(product_id: product2.id, skill_id: 101)
Recommendation.create(product_id: product3.id, skill_id: 101)

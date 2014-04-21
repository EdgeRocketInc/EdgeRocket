# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Account.create(id: 1, company_name: 'EdgeRocket, Inc.')
Account.create(id: 2, company_name: 'TechCorp')

# Vendors should be populated by DBA/developers
Vendor.create(id: 1, name: 'Coursera', logo_file_name: 'coursera-logo.png' )
Vendor.create(id: 2, name: 'Youtube', logo_file_name: 'you_tube.png' )
Vendor.create(id: 3, name: 'Udemy', logo_file_name: 'logo_udemy.png' )
Vendor.create(id: 4, name: 'Blog', logo_file_name: 'universal-blog-icon.png' )
Vendor.create(id: 5, name: 'Google Ventures', logo_file_name: 'gv.jpg' )
Vendor.create(id: 6, name: 'Lynda', logo_file_name: 'lynda_logo2k-d_144x.png' )
Vendor.create(id: 7, name: 'VTC', logo_file_name: 'vtc-logo.jpg' )
Vendor.create(id: 8, name: 'Skillshare', logo_file_name: 'skillshare-logo-160-20.png' )
Vendor.create(id: 9, name: 'General Assmebly', logo_file_name: 'ga-lockup.png' )
Vendor.create(id: 10, name: 'edX', logo_file_name: 'edx-logo-header.png' )
Vendor.create(id: 11, name: 'Code School', logo_file_name: 'code-school-logo-brackets.png' )
Vendor.create(id: 12, name: 'TED', logo_file_name: 'ted-logo.png' )
Vendor.create(id: 13, name: 'HBX', logo_file_name: 'hbx-logo.png' )

User.create(id: 0, email: 'superadmin@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 1, email: 'admin@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 2, email: 'peter@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 3, email: 'alexey@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 10, email: 'Jane.Smith@TechCorp.com', password: 'TechCorp!', account_id: 2)
User.create(id: 11, email: 'Jose.Calderon@TechCorp.com', password: 'TechCorp!', account_id: 2)

Role.create(id: 1, name: 'SA', user_id: 0)
Role.create(id: 2, name: 'Admin', user_id: 1)
Role.create(id: 11, name: 'Admin', user_id: 11)


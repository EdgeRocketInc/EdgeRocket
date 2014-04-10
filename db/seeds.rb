# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Account.create(id: 1, company_name: 'EdgeRocket, Inc.')

# Vendors should be populated by DBA/developers
Vendor.create(id: 1, name: 'Coursera')
Vendor.create(id: 2, name: 'Youtube')
Vendor.create(id: 3, name: 'Udemy')
Vendor.create(id: 4, name: 'Blog')

User.create(id: 0, email: 'superadmin@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 1, email: 'admin@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 2, email: 'peter@edgerocket.co', password: 'ER0cket!', account_id: 1)
User.create(id: 3, email: 'alexey@edgerocket.co', password: 'ER0cket!', account_id: 1)

Role.create(id: 1, name: 'SA', user_id: 0)
Role.create(id: 2, name: 'Admin', user_id: 1)


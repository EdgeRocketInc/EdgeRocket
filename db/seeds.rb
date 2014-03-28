# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Vendors should be populated by DBA/developers
Vendor.create(id: 1, name: 'Coursera')
Vendor.create(id: 2, name: 'Youtube')
Vendor.create(id: 3, name: 'Udemy')

User.create(id: 0, email: 'superadmin@edgerocket.co', password: 'ER0cket!')
User.create(id: 1, email: 'admin@edgerocket.co', password: 'ER0cket!')
User.create(id: 2, email: 'user@edgerocket.co', password: 'ER0cket!')

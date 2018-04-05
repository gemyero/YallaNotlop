# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: 'mohamed', password:'123456', email:'mohamed@yahoo.com', provider: 'local')
User.create(name: 'ahmed', password:'123456', email:'ahmed@yahoo.com', provider: 'local')
User.create(name: 'gemy', password:'123456', email:'gemy@yahoo.com', provider: 'local')
User.create(name: 'tarek', password:'123456', email:'tarek@yahoo.com', provider: 'local')
User.create(name: 'hassan', password:'123456', email:'hassan@yahoo.com', provider: 'local')

User.first.groups << Group.create(name: 'os', user:User.first)
Group.first.users << User.find(2)
Group.first.users << User.find(3)
Group.first.users << User.find(4)
User.first.groups << Group.create(name: 'sd', user:User.first)
User.first.groups << Group.create(name: 'iot', user:User.first)
User.first.groups << Group.create(name: 'cloud', user:User.first)




# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Status.create(name: 'В наличии')
Status.create(name: 'Продан')
Status.create(name: 'Брак')

Store.create(name: 'Точка 1')
Store.create(name: 'Точка 2')
Store.create(name: 'Склад')

Item.create(name: 'Iphone', purchase: 7.80, retail: 400, status_id: 1, store_id: 1)
Item.create(name: 'Samsung', purchase: 8.30, retail: 500, status_id: 2, store_id: 2)
Item.create(name: 'HTC', purchase: 5.40, retail: 600, status_id: 3, store_id: 3)

User.create(
    email: "5773480@gmail.com",
    password: 5956861,
    password_confirmation: 5956861
)
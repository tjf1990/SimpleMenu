User.create(email:'tferris1990@gmail.com', password: 'password', password_confirmation: 'password')

FoodItem.create!(name: 'Chicken Parmesan', description: 'Just like mom used to make! We just slather it in motherfuckin sauce!', is_alcoholic: false, price: 1.0)

#(0..100).each {|i| FoodTest.create!(name:"FoodItem #{i}", price: 2.0, is_alcoholic: true)}

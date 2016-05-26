require 'random_data'

# Create an admin user
admin = User.create!(
  email: 'admin@example.com',
  password: 'password',
  # role: 'admin'
)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

# Create a member
member = User.create!(
  email: 'member@example.com',
  password: 'password'
)

# Create Users
5.times do
  User.create!(
    email: Faker::Internet.safe_email,
    password: Faker::Internet.password(10, 20, true, true)
  )
end
users = User.all

# Create wikis
50.times do
  wiki = Wiki.create!(
    user: users.sample,
    title: Faker::Hipster.sentence(3, true, 2),
    body: Faker::Lorem.paragraph(2, true, 4)
  )
  wiki.update_attribute(:created_at, Faker::Time.between(DateTime.now - 365, DateTime.now))
end
wikis = Wiki.all

puts 'Seed finished'
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"

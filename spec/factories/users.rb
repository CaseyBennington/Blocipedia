FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
end

FactoryGirl.define do
  factory :user, class: 'User' do
    email
    password '12345678'
    password_confirmation '12345678'
    confirmed_at Date.today
  end
end

FactoryGirl.define do
  factory :baduser, class: 'User' do
    email 'c'
    password '1'
    password_confirmation '1'
    confirmed_at Date.today
  end
end

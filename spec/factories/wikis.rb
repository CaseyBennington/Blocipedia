FactoryGirl.define do
  factory :wiki do
    title Faker::Hipster.sentence(3, true, 2)
    body Faker::Lorem.paragraph(2, true, 4)
    private false
    user nil
  end
end

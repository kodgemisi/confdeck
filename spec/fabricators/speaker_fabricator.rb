Fabricator(:speaker) do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  facebook { Faker::Internet.user_name }
  twitter { Faker::Internet.user_name  }
  github { Faker::Internet.user_name }
  phone { Faker::PhoneNumber.cell_phone }
  bio { Faker::Lorem.paragraph }
end

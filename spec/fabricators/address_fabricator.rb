Fabricator(:address) do
  info { Faker::Lorem.paragraph }
  lat { Faker::Address.latitude }
  lon { Faker::Address.longitude  }
  city { Faker::Address.city }
end

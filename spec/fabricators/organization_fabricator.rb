Fabricator(:organization) do
  name { Faker::App.name }
  website { Faker::Internet.url }
end
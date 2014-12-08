Fabricator(:conference) do
  name { Faker::Name.name }
  summary { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
  email { Faker::Internet.email }
  from_date { "04/04/2014" }
  to_date { "04/04/2014" }
  organizations { [Fabricate(:organization)] }
end
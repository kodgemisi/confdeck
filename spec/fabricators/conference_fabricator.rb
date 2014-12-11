Fabricator(:conference) do
  name { Faker::Name.name }
  summary { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
  email { Faker::Internet.email }
  from_date { "10/12/2014" }
  to_date { "12/12/2014" }
  organizations { [Fabricate(:organization)] }
end


Fabricator(:one_day_conference, from: :conference) do
  name { Faker::Name.name }
  summary { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
  email { Faker::Internet.email }
  from_date { "12/12/2014" }
  to_date { "12/12/2014" }
  start_time { "11:00"}
  end_time { "15:00"}
  organizations { [Fabricate(:organization)] }
end
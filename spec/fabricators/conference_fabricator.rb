include ConferencesHelper

Fabricator(:conference) do
  name { Faker::Name.name }
  summary { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
  email { Faker::Internet.email }
  from_date { date_to_s Date.today }
  to_date { date_to_s Date.tomorrow }
  organizations { [Fabricate(:organization)] }
  address { Fabricate(:address) }
  conference_admins { [Fabricate(:user)]}
end


Fabricator(:one_day_conference, from: :conference) do
  name { Faker::Name.name }
  summary { Faker::Lorem.sentence }
  description { Faker::Lorem.paragraph }
  email { Faker::Internet.email }
  from_date { date_to_s Date.tomorrow }
  to_date { date_to_s Date.tomorrow }
  start_time { "11:00"}
  end_time { "15:00"}
  organizations { [Fabricate(:organization)] }
  speech_types rand: 5, fabricator: :speech_type

end
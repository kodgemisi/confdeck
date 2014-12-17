Fabricator(:topic) do
  abstract { Faker::Lorem.paragraph }
  additional_info { Faker::Lorem.paragraph }
  detail { Faker::Lorem.paragraph }
  subject { Faker::Lorem.sentence }
  speakers(count: 3)
end

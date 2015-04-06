Fabricator(:email_template_type) do
  title { Faker::Lorem.sentence }
  default_subject { Faker::Lorem.sentence }
  default_body { Faker::Lorem.paragraph }
  type_name { ''}
end


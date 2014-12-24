Fabricator(:user) do
  email { Faker::Internet.email }
  password "jdasjfjda"
end

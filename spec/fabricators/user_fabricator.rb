Fabricator(:user) do
  email { Faker::Internet.email }
  password "jdasjfjda"
  role :user
end

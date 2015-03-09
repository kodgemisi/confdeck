Fabricator(:speech_type) do
  type_name_en { Faker::Lorem.word + "-en" }
  type_name_tr { Faker::Lorem.word + "-tr" }
end

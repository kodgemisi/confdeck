json.array! @users do |user|
  json.(user, :id, :email)
  json.organizations user.organizations do |org|
    json.name org.name
  end
end

user_data = JSON.parse(File.read('db/seed_data/users.json'))

user_data.each do |user|
  User.create!(user)
end

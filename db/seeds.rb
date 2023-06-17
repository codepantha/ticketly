# frozen_string_literal: true

unless User.exists?(email: 'admin@ticketly.com')
  User.create!(email: 'admin@ticketly.com', password: 'password', admin: true)
end

unless User.exists?(email: 'viewer@ticketly.com')
  User.create(email: 'viewer@ticketly.com', password: 'password')
end

['Visual Studio Code', 'Internet Explorer'].each do |name|
  unless Project.exists?(name)
    Project.create!(name: name, description: "A sample project about #{name}")
  end
end

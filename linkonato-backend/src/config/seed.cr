# src/config/seed.cr
require "crypto/bcrypt"
require "../models/user"

if ENV.has_key?("ADMIN_USERNAME") && ENV.has_key?("ADMIN_PASSWORD") && ENV.has_key?("ADMIN_EMAIL")
  username = ENV["ADMIN_USERNAME"].downcase
  unless User.find_by(username: username)
    puts "Criando usuario admin garantido pelo .env: #{username}"
    user = User.new(
      email: ENV["ADMIN_EMAIL"],
      username: username,
      password_hash: Crypto::Bcrypt::Password.create(ENV["ADMIN_PASSWORD"], cost: 10).to_s,
      bio: "Administrador do sistema"
    )
    if user.save
      puts "Usuario admin criado com sucesso!"
    else
      puts "Falha ao criar admin: #{user.errors.map(&.message).join(", ")}"
    end
  end
end

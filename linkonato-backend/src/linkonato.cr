# src/app.cr
require "kemal"
require "./config/database"
require "./models/user"
require "./models/user_link"
require "./middlewares/auth_middleware"
require "./controllers/*"

add_context_storage_type(User)

options "/*" do |env|
  env.response.headers["Access-Control-Allow-Origin"]  = "http://localhost:4321"
  env.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
  env.response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, X-Requested-With"
  env.response.headers["Access-Control-Allow-Credentials"] = "true"
  env.response.status_code = 204
  ""
end

before_all do |env|
  env.response.headers["Access-Control-Allow-Origin"]      = "http://localhost:4321"
  env.response.headers["Access-Control-Allow-Credentials"] = "true"
  env.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
  env.response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, X-Requested-With"
  env.response.headers["Access-Control-Expose-Headers"] = "Authorization"
end

add_handler AuthMiddleware.new

Kemal.run(3000) do
  puts "API rodando → http://localhost:3000"
end

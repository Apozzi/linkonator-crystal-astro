# ╔══════════════════════════════════════════════════════════════╗
# ║                  █░░ █ █▄░█ █▄▀ █▀█ █▄█ ▄▀█ ▀█▀ █▀█ █▀█ ║
# ║                  █▄▄ █ █░▀█ █░█ █▄█ ░█░ █▀█ ░█░ █▄█ █▀▄ ║
# ║                                                              ║
# ║  Bem-vindo ao núcleo de autenticação do Linkonator v9.9      ║
# ║  Aqui nascem os agentes que vão coletar links pelo abyss.   ║
# ║                                                              ║
# ║  • Senhas são trituradas com BCrypt (cost 10) e jogadas     ║
# ║    direto no vault criptográfico — nem o próprio Neo        ║
# ║    conseguiria ler sem a pílula vermelha.                   ║
# ║  • Tokens JWT com 7 dias de expiração, porque até no        ║
# ║    submundo digital a gente precisa dormir algum dia.      ║
# ║  • Patch secreto aplicado: converte $2a$ → $2y$ porque       ║
# ║    algumas libs antigas ainda vivem no passado.             ║
# ║                                                              ║
# ║  "Há uma diferença entre conhecer o caminho                 ║
# ║   e caminhar pelo caminho." — Morpheus (provavelmente)      ║
# ╚══════════════════════════════════════════════════════════════╝


require "crypto/bcrypt"

post "/api/auth/register" do |env|
  data = JSON.parse(env.request.body.not_nil!.gets_to_end)

  user = User.new(
    email: data["email"].as_s,
    username: data["username"].as_s.downcase,
    password_hash: Crypto::Bcrypt::Password.create(data["password"].as_s, cost: 10).to_s
  )

  if user.save
    token = JWT.encode({"user_id" => user.id.not_nil!, "exp" => Time.utc.to_unix + 7.days.to_i}, ENV["JWT_SECRET"], JWT::Algorithm::HS256)
    env.response.status_code = 201
    {token: token, user: {id: user.id, username: user.username, email: user.email}}.to_json
  else
    env.response.status_code = 422
    {error: user.errors.map(&.message).join(", ")}.to_json
  end
end

post "/api/auth/login" do |env|
  data = JSON.parse(env.request.body.not_nil!.gets_to_end)
  email = data["email"].as_s
  password = data["password"].as_s

  user = User.find_by(email: email)

  if user && valid_password?(user.password_hash, password)
    token = JWT.encode(
      {"user_id" => user.id.not_nil!, "exp" => Time.utc.to_unix + 7.days.to_i},
      ENV["JWT_SECRET"],
      JWT::Algorithm::HS256
    )
   
    {token: token, user: {id: user.id, username: user.username}}.to_json
  else
    env.response.status_code = 401
    {error: "Email ou senha incorretos"}.to_json
  end
end

private def valid_password?(stored_hash : String, provided_password : String) : Bool
  hash_to_check = stored_hash.starts_with?("$2a$") ? stored_hash.sub("$2a$", "$2y$") : stored_hash
  bcrypt = Crypto::Bcrypt::Password.new(hash_to_check)
  bcrypt.verify(provided_password)
rescue
  false
end

# src/middlewares/auth_middleware.cr
require "jwt"
require "../models/user"

class AuthMiddleware < Kemal::Handler

  EXCLUDED = [
    {path: "/api/auth/login",    method: "POST"},
    {path: "/api/auth/register", method: "POST"},
    {path: "/api/users",        method: "GET"}
  ]

  def call(env)
    if env.request.method == "OPTIONS"
      return call_next(env)
    end
    excluded = EXCLUDED.any? do |rule|
      env.request.path.starts_with?(rule[:path]) &&
      env.request.method == rule[:method]
    end

    return call_next(env) if excluded

    token = env.request.headers["Authorization"]?.try(&.split.last)

    unless token
      return unauthorized(env, "Token não informado")
    end

    begin
      payload, _ = JWT.decode(token, ENV["JWT_SECRET"], JWT::Algorithm::HS256)

      user_id = payload["user_id"].as_i64
    rescue e
      print(e);
      return unauthorized(env, "Token inválido ou expirado")
    end

    user = User.find(user_id)
    unless user
      return unauthorized(env, "Usuário não encontrado")
    end

    env.set("current_user", user)

    call_next(env)
  end

  private def unauthorized(env, message)
    env.response.status_code = 401
    env.response.content_type = "application/json"
    env.response.print({error: message}.to_json)
  end
end
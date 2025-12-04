get "/api/users/:username" do |env|
  username = env.params.url["username"].downcase
  user = User.find_by(username: username)

  if user
    links = UserLink.where(user_id: user.id).order(position: :asc)
    {user: {username: user.username, bio: user.bio}, links: links.map(&.to_h)}.to_json
  else
    env.response.status_code = 404
    {error: "Usuário não encontrado"}.to_json
  end
end
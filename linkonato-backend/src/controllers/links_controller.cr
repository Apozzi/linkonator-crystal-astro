get "/api/me" do |env|
  user = env.get("current_user").as(User)
  links = UserLink.where(user_id: user.id).order(position: :asc)
  {user: {id: user.id, username: user.username, email: user.email}, links: links.map(&.to_h)}.to_json
end

post "/api/links" do |env|
  user = env.get("current_user").as(User)
  data = JSON.parse(env.request.body.not_nil!.gets_to_end)

  max_pos = UserLink.where(user_id: user.id).map(&.position).max? || -1
  link = UserLink.new(
    title: data["title"].as_s,
    url: data["url"].as_s,
    user_id: user.id,
    position: max_pos + 1,
    created_at: Time.utc,
    updated_at: Time.utc
  )

  if link.save
    env.response.status_code = 201
    link.to_h.to_json
  else
    env.response.status_code = 422
    {error: link.errors.map(&.message).join(", ")}.to_json
  end
end

delete "/api/links/:id" do |env|
  user = env.get("current_user").as(User)
  link = UserLink.find!(env.params.url["id"].to_i64)

  halt env, status_code: 403 if link.user_id != user.id

  link.destroy
  {success: true}.to_json
end
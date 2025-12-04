# src/config/database.cr
require "granite"
require "granite/adapter/pg"

Granite::Connections << Granite::Adapter::Pg.new(
  name: "pg",
  url: "postgres://postgres:postgres@127.0.0.1:5432/teste"
)

ENV["JWT_SECRET"] ||= "sua_s"
class User < Granite::Base
  connection pg
  table users

  has_many :user_links, class_name: UserLink

  column id : Int64, primary: true
  column email : String, unique: true
  column username : String, unique: true
  column password_hash : String
  column bio : String?

  timestamps
end
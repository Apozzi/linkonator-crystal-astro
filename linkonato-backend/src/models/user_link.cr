require "granite"

class UserLink < Granite::Base
  connection pg
  table links

  belongs_to :user

  column id : Int64, primary: true
  column title : String
  column url : String
  column position : Int32 = 0
  column created_at : Time
  column updated_at : Time

  before_save do
    self.created_at = Time.utc if created_at.nil?
    self.updated_at = Time.utc
  end

  before_update { self.updated_at = Time.utc }
end
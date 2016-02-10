require 'bcrypt'

class User < ActiveRecord::Base
  include TokenAuthenticatable

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
end

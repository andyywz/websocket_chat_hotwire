module UsersHelper
  def user_gravatar_url
    # md5_hash = Digest::MD5.hexdigest(current_user.email)
    md5_hash = Digest::MD5.hexdigest("andyywz@gmail.com")
    "https://www.gravatar.com/avatar/#{md5_hash}.jpg?s=400"
  end
end

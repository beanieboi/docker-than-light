class User < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    create! do |user|
      user.github_uid = auth['uid']
      user.email = auth['info']['email']
    end
  end
end

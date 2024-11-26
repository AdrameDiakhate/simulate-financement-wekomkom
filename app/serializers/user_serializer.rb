# app/serializers/user_serializer.rb
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :firstname, :lastname, :username, :birthday, :job_title, :profile_image, :city, :gender, :age
end

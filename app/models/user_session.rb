class UserSession
    attr_accessor :id, :email, :firstname, :lastname, :username, :birthday, :job_title, :profile_image, :city, :gender, :age
  
    def initialize(attributes = {})
      attributes.each do |key, value|
        send("#{key}=", value) if respond_to?("#{key}=")
      end
    end
  
    # Pour s'assurer que `as_json` retourne le format attendu
    def as_json(_options = {})
      {
        id: id,
        email: email,
        firstname: firstname,
        lastname: lastname,
        username: username,
        birthday: birthday,
        job_title: job_title,
        profile_image: profile_image,
        city: city,
        gender: gender,
        age: age
      }
    end
  end
  
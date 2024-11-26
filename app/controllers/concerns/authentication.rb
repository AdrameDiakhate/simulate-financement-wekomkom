module Authentication
  extend ActiveSupport::Concern

  # Méthode pour obtenir l'utilisateur actuel à partir du token JWT
#   SECRET_KEY = 'd2Vrb21rb20gand0IHNlY3JldCB0b2tlbiBqd3Qg'
  def current_user
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      begin
        decoded_token = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' })
        user_id = decoded_token[0]['user_id']
        @current_user ||= User.find_by(id: user_id)
      rescue JWT::DecodeError
        nil
      end
    end
  end

  # Méthode pour vérifier si l'utilisateur est authentifié
  def authenticate_user!
    Rails.logger.debug("Session content: #{session[:user].inspect}")
    unless session[:user] && session[:user]["id"].present?
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
  
  
end

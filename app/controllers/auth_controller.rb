class AuthController < ApplicationController
    include Authentication
  
    before_action :authenticate_user!, only: [:profile]
  
    def callback
      token = params[:token]
      if token.blank?
        redirect_to root_path, alert: 'Token manquant.'
        return
      end
  
      begin
        # Décoder le token
        decoded_token = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, { algorithm: 'HS256' })
        user_data = decoded_token[0]  

       # Enregistrer les données utilisateur dans la session
        session[:user] = {
            "id" => user_data['id'],
            "email" => user_data['email'],
            "firstname" => user_data['firstName'],
            "lastname" => user_data['lastName'],
            "username" => user_data['username'],
            "birthday" => user_data['birthday'],
            "job_title" => user_data['job_title'],
            "profile_image" => user_data['profile_image'],
            "city" => user_data['city'],
            "gender" => user_data['gender'],
            "age" => user_data['age']
          }
          


        #Logger la valeur de session
        Rails.logger.info("Here is my session: #{session[:user]}")
  

  
        # Rediriger vers la page de profil
        redirect_to user_profile_path, notice: "Bienvenue #{user_data['user_firstname']}!"
      rescue JWT::DecodeError => e
        redirect_to root_path, alert: "Token invalide : #{e.message}"
      end
    end
  
    def profile
        Rails.logger.info("Session data: #{session[:user].inspect}")
        
        if session[:user]
          # Charger les données utilisateur comme un objet UserSession si nécessaire
          user_session = UserSession.new(session[:user])
          
          # Sérialiser et encapsuler les données sous une clé "user"
          render json: { user: user_session.as_json }, status: :ok
        else
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end
      
       
      
    private
           
  end
  
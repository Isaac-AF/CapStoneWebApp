# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super do |user|
      if user.persisted?
            chat = OpenAI::Chat.new
            chat.model = 'o4-mini'
            chat.system("You are an expert nutritionist. Your job is to give a precise estimate of the daily macros (calories, carbohydrates, protein, fiber, fat) that someone should try to hit in order to attain their selected goals, provided information about the person.")
            chat.schema = '{
              "name": "nutrition_info",
              "schema": {
                "type": "object",
                "properties": {
                  "carbohydrates": {
                    "type": "number",
                    "description": "Amount of carbohydrates in grams."
                  },
                  "protein": {
                    "type": "number",
                    "description": "Amount of protein in grams."
                  },
                  "fat": {
                    "type": "number",
                    "description": "Amount of fat in grams."
                  },
                  "total_calories": {
                    "type": "number",
                    "description": "Total calories in kcal."
                  },
                  "fiber": {
                    "type": "string",
                    "description": "Total fiber in grams."
                  }
                },
                "required": [
                  "carbohydrates",
                  "protein",
                  "fat",
                  "total_calories",
                  "fiber"
                ],
                "additionalProperties": false
              },
              "strict": true
            }'

              chat.user("The user's height is #{user.height} inches, weight is #{user.weight} lbs, age is #{user.birthday}, sex is #{user.sex}, activity level is #{user.activity_level}, and their goals are: #{[user.primary_goal, user.secondary_goal, user.tertiary_goal].compact.join(", ")}.")

              result = chat.assistant!

              user.update!(
                target_calories: result.fetch("total_calories"),
                target_carbs: result.fetch("carbohydrates"),
                target_protein: result.fetch("protein"),
                target_fat: result.fetch("fat"),
                target_fiber: result.fetch("fiber")
                )
      end
    end
  end
  

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

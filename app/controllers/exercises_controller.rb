class ExercisesController < ApplicationController
  def index
    matching_exercises = Exercise.all

    @list_of_exercises = matching_exercises.order({ :created_at => :desc })

    session[:return_to_workout_sets] = params[:return_to] if params[:return_to].present?

    render({ :template => "exercises/index" })
  end

  def show
    the_id = params.fetch("exercise_id")

    matching_exercises = Exercise.where({ :id => the_id })

    @the_exercise = matching_exercises.at(0)

    render({ :template => "exercises/show" })
  end

  def create
    the_exercise = Exercise.new
    the_exercise.exercise_name = params.fetch("query_exercise_name")
    the_exercise.primary_muscle = params.fetch("query_primary_muscle")
    the_exercise.secondary_muscle = params.fetch("query_secondary_muscle")
    the_exercise.tertiary_muscle = params.fetch("query_tertiary_muscle")
    the_exercise.user_id = current_user.id

    if the_exercise.valid?
      the_exercise.save
      redirect_to("/exercises", { :notice => "Exercise created successfully." })
    else
      redirect_to("/exercises", { :alert => the_exercise.errors.full_messages.to_sentence })
    end
  end

def ai_process
  the_name = params.fetch("query_exercise_name")
  the_image = params.fetch("image_param","")
  the_description = params.fetch("description_param")
  
  chat = OpenAI::Chat.new
    chat.model = 'o4-mini'
    chat.system("You are an expert personal trainer. Your job is to determine the common name and muscles worked of an exercise given a description and images from the user. Provide primary, secondary, and tertiary muscle groups worked. If no secondary or tertiary muscle groups are relevant for a given exercise, return a blank value.")
    chat.schema = '{
      "name": "exercise_info",
      "schema": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string",
            "description": "Name exercise is commonly referred to."
          },
            "primary_muscle_group": {
            "type": "string",
            "description": "Primary muscle group the exercise works."
          },
            "secondary_muscle_group": {
            "type": "string",
            "description": "Secondary muscle group the exercise works, if applicable."
          },
            "tertiary_muscle_group": {
            "type": "string",
            "description": "Tertiary muscle group the exercise works, if applicable."
          }
        },
        "required": [
          "name",
          "primary_muscle_group",
          "secondary_muscle_group",
          "tertiary_muscle_group"
        ],
        "additionalProperties": false
      },
      "strict": true
    }'

    chat.user("Here is what the user called the exercise: #{the_name}")

    # Add images to content
    if the_image.present?
      chat.user("Here's an image of the equipment used:", image: the_image)
    end

    # Add description text
    if the_description.present?
      chat.user("Here's a description of the exercise: #{the_description}")
    end

    result = chat.assistant!

    the_exercise = Exercise.new
    the_exercise.exercise_name = result.fetch("name")
    the_exercise.primary_muscle = result.fetch("primary_muscle_group")
    the_exercise.secondary_muscle = result.fetch("secondary_muscle_group")
    the_exercise.tertiary_muscle = result.fetch("tertiary_muscle_group")
    the_exercise.user_id = current_user.id

    if the_exercise.valid?
      the_exercise.save
      redirect_to("/exercises", { :notice => "Exercise created successfully." })
    else
      redirect_to("/exercises", { :alert => the_exercise.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("exercise_id")
    the_exercise = Exercise.where({ :id => the_id }).at(0)

    the_exercise.exercise_name = params.fetch("query_exercise_name")
    the_exercise.primary_muscle = params.fetch("query_primary_muscle")
    the_exercise.secondary_muscle = params.fetch("query_secondary_muscle")
    the_exercise.tertiary_muscle = params.fetch("query_tertiary_muscle")

    if the_exercise.valid?
      the_exercise.save
      redirect_to("/exercises/#{the_exercise.id}", { :notice => "Exercise updated successfully."} )
    else
      redirect_to("/exercises/#{the_exercise.id}", { :alert => the_exercise.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("exercise_id")
    the_exercise = Exercise.where({ :id => the_id }).at(0)

    the_exercise.destroy

    redirect_to("/exercises", { :notice => "Exercise deleted successfully."} )
  end
end

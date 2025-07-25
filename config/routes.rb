Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
    # Routes for the Workout set resource:

  # CREATE
  post("/insert_workout_set", { :controller => "workout_sets", :action => "create" })
          
  # READ
  get("/workout_sets/:workout_id", { :controller => "workout_sets", :action => "index" })
  
  get("/workout_sets/:workout_id/:set_id", { :controller => "workout_sets", :action => "show" })

  get "/next_set_number", to: "workout_sets#next_set_number"
  get "/max_weight_and_reps", to: "workout_sets#max_weight_and_reps"
  
  # UPDATE
  
  post("/modify_workout_set/:set_id", { :controller => "workout_sets", :action => "update" })
  
  # DELETE
  get("/delete_workout_set/:set_id", { :controller => "workout_sets", :action => "destroy" })

  #------------------------------

  # Routes for the Exercise resource:

  # CREATE
  post("/insert_exercise", { :controller => "exercises", :action => "create" })
  post("/process_exercise", { :controller => "exercises", :action => "ai_process" })
          
  # READ
  get("/exercises", { :controller => "exercises", :action => "index" })
  
  get("/exercises/:exercise_id", { :controller => "exercises", :action => "show" })
  
  # UPDATE
  
  post("/modify_exercise/:exercise_id", { :controller => "exercises", :action => "update" })
  
  # DELETE
  post("/delete_exercise/:exercise_id", { :controller => "exercises", :action => "destroy" })

  #------------------------------

  # Routes for the Workout resource:

  # CREATE
  post("/process_activity", { :controller => "workouts", :action => "ai_process" })
  post("/insert_activity", { :controller => "workouts", :action => "manual_insert" })
  post("/new_workout", { :controller => "workouts", :action => "create" })
          
  # READ
  get("/workouts", { :controller => "workouts", :action => "index" })
  
  get("/workouts/:date/:user_id", { :controller => "workouts", :action => "show" })
  
  # UPDATE
  
  post("/modify_workout/:workout_id", { :controller => "workouts", :action => "update" })
  post("/finish_workout", { :controller => "workouts", :action => "finish" })

  # DELETE
  get("/delete_workout/:workout_id", { :controller => "workouts", :action => "destroy" })

  # Navigation
  post("/delete_if_empty_and_back", { :controller => "workouts", :action => "delete_if_empty_and_back" })

  #------------------------------

  # Routes for the Meal resource:

  # CREATE
  post("/process_meal", { :controller => "meals", :action => "ai_process" })
  post("/insert_meal", { :controller => "meals", :action => "manual_insert" })
          
  # READ
  get("/meals", { :controller => "meals", :action => "index" })
  
  get("/meals/:date/:user_id", { :controller => "meals", :action => "show" })
  
  # UPDATE
  
  post("/modify_meal/:meal_id", { :controller => "meals", :action => "update" })
  
  # DELETE
  get("/delete_meal/:meal_id", { :controller => "meals", :action => "destroy" })

  #------------------------------


  get("/", { :controller => "users", :action => "index"})

  # Routes for the User resource:

  # READ
  get("/users/:id", { :controller => "users", :action => "show" })

  # CREATE
  post("/insert_user", { :controller => "users", :action => "create" })

  # UPDATE
  post("/day_recommend", { :controller => "users", :action => "recommend" })
  post("/week_nutrition_rating", { :controller => "users", :action => "rate_nutrition" })
  post("/week_activity_rating", { :controller => "users", :action => "rate_activity" })
  
end

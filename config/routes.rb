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
  
  # UPDATE
  
  post("/modify_workout_set/:set_id", { :controller => "workout_sets", :action => "update" })
  
  # DELETE
  get("/delete_workout_set/:set_id", { :controller => "workout_sets", :action => "destroy" })

  #------------------------------

  # Routes for the Exercise resource:

  # CREATE
  post("/insert_exercise", { :controller => "exercises", :action => "create" })
          
  # READ
  get("/exercises/", { :controller => "exercises", :action => "index" })
  
  get("/exercises/:exercise_id", { :controller => "exercises", :action => "show" })
  
  # UPDATE
  
  post("/modify_exercise/:path_id", { :controller => "exercises", :action => "update" })
  
  # DELETE
  get("/delete_exercise/:path_id", { :controller => "exercises", :action => "destroy" })

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


  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"

  get("/", { :controller => "users", :action => "index"})

  # Routes for the User resource:

  # READ
  get("/users/:id", { :controller => "users", :action => "show" })

  # CREATE
  post("/insert_user", { :controller => "users", :action => "create" })
  
end

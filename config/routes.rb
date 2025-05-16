Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  devise_for :users
  # Routes for the Workout rep resource:

  # CREATE
  post("/insert_workout_rep", { :controller => "workout_reps", :action => "create" })
          
  # READ
  get("/workout_reps", { :controller => "workout_reps", :action => "index" })
  
  get("/workout_reps/:path_id", { :controller => "workout_reps", :action => "show" })
  
  # UPDATE
  
  post("/modify_workout_rep/:path_id", { :controller => "workout_reps", :action => "update" })
  
  # DELETE
  get("/delete_workout_rep/:path_id", { :controller => "workout_reps", :action => "destroy" })

  #------------------------------

  # Routes for the Workout set resource:

  # CREATE
  post("/insert_workout_set", { :controller => "workout_sets", :action => "create" })
          
  # READ
  get("/workout_sets", { :controller => "workout_sets", :action => "index" })
  
  get("/workout_sets/:path_id", { :controller => "workout_sets", :action => "show" })
  
  # UPDATE
  
  post("/modify_workout_set/:path_id", { :controller => "workout_sets", :action => "update" })
  
  # DELETE
  get("/delete_workout_set/:path_id", { :controller => "workout_sets", :action => "destroy" })

  #------------------------------

  # Routes for the Exercise resource:

  # CREATE
  post("/insert_exercise", { :controller => "exercises", :action => "create" })
          
  # READ
  get("/exercises", { :controller => "exercises", :action => "index" })
  
  get("/exercises/:path_id", { :controller => "exercises", :action => "show" })
  
  # UPDATE
  
  post("/modify_exercise/:path_id", { :controller => "exercises", :action => "update" })
  
  # DELETE
  get("/delete_exercise/:path_id", { :controller => "exercises", :action => "destroy" })

  #------------------------------

  # Routes for the Workout resource:

  # CREATE
  post("/insert_workout", { :controller => "workouts", :action => "create" })
          
  # READ
  get("/workouts", { :controller => "workouts", :action => "index" })
  
  get("/workouts/:path_id", { :controller => "workouts", :action => "show" })
  
  # UPDATE
  
  post("/modify_workout/:path_id", { :controller => "workouts", :action => "update" })
  
  # DELETE
  get("/delete_workout/:path_id", { :controller => "workouts", :action => "destroy" })

  #------------------------------

  # Routes for the Meal resource:

  # CREATE
  post("/insert_meal", { :controller => "meals", :action => "create" })
          
  # READ
  get("/meals", { :controller => "meals", :action => "index" })
  
  get("/meals/:path_id", { :controller => "meals", :action => "show" })
  
  # UPDATE
  
  post("/modify_meal/:path_id", { :controller => "meals", :action => "update" })
  
  # DELETE
  get("/delete_meal/:path_id", { :controller => "meals", :action => "destroy" })

  #------------------------------


  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"

  get("/", { :controller => "users", :action => "index"})
  get("/create_user", { :controller => "users", :action => "new_user"})
  get("/user/:path_id", { :controller => "users", :action => "show" })
  
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_07_23_044544) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exercises", force: :cascade do |t|
    t.string "exercise_name"
    t.string "primary_muscle"
    t.string "secondary_muscle"
    t.string "tertiary_muscle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["exercise_name"], name: "index_exercises_on_exercise_name"
  end

  create_table "meals", force: :cascade do |t|
    t.date "date_consumed"
    t.string "food_name"
    t.string "rating"
    t.float "calories"
    t.float "protein"
    t.float "fats"
    t.float "carbs"
    t.float "fiber"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "meal_type"
    t.index ["date_consumed"], name: "index_meals_on_date_consumed"
    t.index ["user_id", "date_consumed"], name: "index_meals_on_user_id_and_date_consumed"
    t.index ["user_id"], name: "index_meals_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.date "birthday"
    t.string "sex"
    t.string "activity_level"
    t.string "primary_goal"
    t.string "secondary_goal"
    t.string "tertiary_goal"
    t.string "dietary_restrictions"
    t.string "name"
    t.float "height"
    t.float "weight"
    t.integer "meals_count"
    t.integer "workouts_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "target_calories"
    t.integer "target_protein"
    t.integer "target_carbs"
    t.integer "target_fat"
    t.integer "target_fiber"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workout_sets", force: :cascade do |t|
    t.integer "set_number"
    t.integer "workout_id"
    t.integer "exercise_id"
    t.integer "workout_reps_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight"
    t.index ["exercise_id"], name: "index_workout_sets_on_exercise_id"
    t.index ["workout_id"], name: "index_workout_sets_on_workout_id"
  end

  create_table "workouts", force: :cascade do |t|
    t.datetime "workout_datetime"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "workout_type"
    t.decimal "calories_burned"
    t.integer "rating"
  end

end

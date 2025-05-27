# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

exercises = [
  { exercise_name: "Barbell Squat", primary_muscle: "Quadriceps", secondary_muscle: "Glutes", tertiary_muscle: "Hamstrings" },
  { exercise_name: "Deadlift", primary_muscle: "Hamstrings", secondary_muscle: "Glutes", tertiary_muscle: "Lower Back" },
  { exercise_name: "Bench Press", primary_muscle: "Pectorals", secondary_muscle: "Triceps", tertiary_muscle: "Deltoids" },
  { exercise_name: "Overhead Press", primary_muscle: "Deltoids", secondary_muscle: "Triceps", tertiary_muscle: "Upper Chest" },
  { exercise_name: "Bent-Over Row", primary_muscle: "Lats", secondary_muscle: "Rhomboids", tertiary_muscle: "Biceps" },
  { exercise_name: "Pull-Up", primary_muscle: "Lats", secondary_muscle: "Biceps", tertiary_muscle: "Rhomboids" },
  { exercise_name: "Barbell Curl", primary_muscle: "Biceps", secondary_muscle: "Forearms" },
  { exercise_name: "Tricep Pushdown", primary_muscle: "Triceps", secondary_muscle: "Forearms" },
  { exercise_name: "Leg Press", primary_muscle: "Quadriceps", secondary_muscle: "Glutes", tertiary_muscle: "Hamstrings" },
  { exercise_name: "Romanian Deadlift", primary_muscle: "Hamstrings", secondary_muscle: "Glutes", tertiary_muscle: "Lower Back" },
  { exercise_name: "Lateral Raise", primary_muscle: "Deltoids", secondary_muscle: "Trapezius" },
  { exercise_name: "Face Pull", primary_muscle: "Rear Deltoids", secondary_muscle: "Trapezius", tertiary_muscle: "Rhomboids" },
  { exercise_name: "Chest Fly", primary_muscle: "Pectorals", secondary_muscle: "Deltoids" },
  { exercise_name: "Seated Row", primary_muscle: "Lats", secondary_muscle: "Rhomboids", tertiary_muscle: "Biceps" },
  { exercise_name: "Calf Raise", primary_muscle: "Calves" },
  { exercise_name: "Hip Thrust", primary_muscle: "Glutes", secondary_muscle: "Hamstrings" },
  { exercise_name: "Incline Bench Press", primary_muscle: "Upper Chest", secondary_muscle: "Deltoids", tertiary_muscle: "Triceps" },
  { exercise_name: "Cable Crossover", primary_muscle: "Pectorals", secondary_muscle: "Deltoids" },
  { exercise_name: "Dumbbell Shrug", primary_muscle: "Trapezius" },
  { exercise_name: "Ab Wheel Rollout", primary_muscle: "Abdominals", secondary_muscle: "Hip Flexors" }
]

exercises.each do |attrs|
  exercise = Exercise.find_or_initialize_by(exercise_name: attrs[:exercise_name])
  exercise.assign_attributes(
    primary_muscle: attrs[:primary_muscle],
    secondary_muscle: attrs[:secondary_muscle],
    tertiary_muscle: attrs[:tertiary_muscle]
  )
  if exercise.new_record?
    exercise.save!
    puts "Created: #{exercise.exercise_name}"
  else
    puts "Skipped (already exists): #{exercise.exercise_name}"
  end
end

puts "Seeded #{Exercise.count} exercises."

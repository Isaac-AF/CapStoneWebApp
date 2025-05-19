module ApplicationHelper
  def height_label(inches)
    feet = inches / 12
    inches_remaining = inches % 12
    "#{feet}'#{inches_remaining}\""
  end

  def goal_options
    [
      ["Lose Fat/Weight", "Fat"],
      ["Gain Muscle/Weight", "Muscle"],
      ["Maintain Weight", "Maintain"],
      ["Improve Endurance", "Endurance"],
      ["Increase Strength", "Strength"],
      ["Eat Healthier/Improve Nutrition", "Nutrition"],
      ["Increase Energy/Well-being", "Energy"],
      ["Support Dietary Needs (e.g. diabetic, gluten free)", "Dietary"]
    ]
  end
end

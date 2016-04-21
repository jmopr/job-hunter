def matching_algorithm(parsed_requirements)
  detractors = ["advanced", "expert", "senior", "years"]
  my_skills = {
    "Ruby" => 0.87, # based on 13/15 here: https://gist.github.com/ryansobol/5252653
    "Rails" => 0.65,
    "Git" => 0.69, # based on knowing 22/32 commands here: https://git-scm.com/docs
    "Javascript" => 0.65,
    "HTML" => 1.0,
    "CSS" => 0.87,
    "jQuery" => 0.55,
    "Python" => 0.7,
    "Agile" => 0.55, # Never used it but have read & learned about it
    "AJAX" => 1.0, # I know how the xhr object works + jQuery .post, .get & .ajax
    "Leadership" => 0.5
  }
  match = 0
  requirements_total = parsed_requirements.length

  parsed_requirements.each do |requirement|
    my_skills.keys.each do |skill|
      if requirement.downcase.include? skill.downcase
        detraction = detractors.any? { |det| requirement.downcase.match(/#{det}/) }
        match += detraction ? my_skills[skill] : 1
      end
    end
  end
  match_percent = ((match.to_f / requirements_total) * 100)
  match_percent > 100 ? 100.00 : match_percent
end

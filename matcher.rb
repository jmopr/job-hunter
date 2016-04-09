# Matching algorithm
# something that checks your skills against the ones in the job post
# and generates an "estimated percent match"
# and only apply to anything with 50% or above match

# def matching_algorithm(parsed_requirements)
#   my_skills = ["Ruby", "Rails", "Git", "Javascript", "HTML", "CSS", "jQuery", "Python", "Agile"]
#   match = 0
#   requirements_total = parsed_requirements.length
#
#   parsed_requirements.each do |requirement|
#     my_skills.each do |skill|
#       if requirement.downcase.include? skill.downcase
#         match += 1
#       end
#     end
#   end
#   estimate_percent_match = match.to_f / requirements_total
#
#   if estimate_percent_match > 0.5
#     puts "Apply to this Job!!!"
#   else
#     puts "Access Denied..."
#   end
# end
#
# def requirements_parser(requirements)
#   matching_algorithm(requirements)
# end

# requirements = ["PHP, MySQL", "SOLID design principles including Dependency Injection and Domain Driven Design",
#                 "Familiar with NodeJS / Cordova / React / Angular", "Familiar with Amazon AWS / Heroku",
#                 "Familiar with RabbitMQ / Redis / Memcache", "Familiar with modern stacks and Dev-Ops (CoreOS, Docker, Chef, etc)",
#                 "Experience with mobile technologies and languages.", "Test Driven Development (PHPUnit is a plus)",
#                 "SQL-compliant RDBMS.", "Apache SOLR is a plus.", "HTML, Javascript/jQuery, AJAX, CSS LESS.",
#                 "Git, SVN, or similar version control systems", "Experience collaborating with a team of developers and programming to a specific coding standard",
#                 "JSON, XML, AJAX and jQuery required", "Basic Linux administration and commands"]
# requirements2 = ["RUBY", "HTML", ".NET", "git", "css"]
# # Get this words from the web page.
# # Requirement keywords = "Description", "Requirements", "Responsibilities"
#
# requirements_parser(requirements)
# requirements_parser(requirements2)

def matching_algorithm(parsed_requirements)
  detractors = ["advanced", "expert", "senior", "years", "leadership"]
  my_skills = {
    "Ruby" => 0.87, # based on 13/15 here: https://gist.github.com/ryansobol/5252653
    "Rails" => 0.7, # find a test for rails
    "Git" => 0.69, # based on knowing 22/32 commands here: https://git-scm.com/docs
    "Javascript" => 0.65, # find a test for JS
    "HTML" => 1.0, # based on gut feeling (find a test)
    "CSS" => 0.87, # based on gut feeling (find a test)
    "jQuery" => 0.54, # find a test for jQuery
    "Python" => 0.88, # find a test for Python
    "Agile" => 0.55, # Never used it but have read & learned about it
    "AJAX" => 1.0, # I know how the xhr object works + jQuery .post, .get & .ajax
    "Leadership" => -1.8
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


reqs = ["Good product intuition",
"Expert-level HTML + CSS skills",
"Advanced knowledge of JavaScript",
"Working in Python & MySQL or Node.js preferred",
"iOS / Android development experience a bonus",
"Ability to work both independently and with teams",
"Strong interpersonal skills",
"Creativity, intelligence, hustle"]
puts matching_algorithm(reqs)

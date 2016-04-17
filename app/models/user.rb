class User < ActiveRecord::Base
  validates :first_name, :last_name, :email, :phone_number, presence: true
  validates :username, uniqueness: true
  has_many :jobs
  has_secure_password
  def get_number_of_repos(user_name)
      response = HTTParty.get("https://api.github.com/users/#{user_name}/repos")
      number = response.length
      names_of_projects =[]
      (0..number-1).each do |i|
        names_of_projects << response[i]["name"]
      end
      names_of_projects
    end
    def get_the_bytes(user_name)
      names = get_number_of_repos(user_name)
      ruby_bytes = []
      lines = []
      names.each do |name|
        response = HTTParty.get("https://api.github.com/repos/#{user_name}/#{name}/languages")
        ruby_bytes << response["Ruby"]
      end
      ruby_bytes.each do |project|
        unless project == nil
          lines << project/40
        end
      end
      [lines.reduce(:+), names.length]
    end
end

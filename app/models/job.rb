class Job < ActiveRecord::Base
  belongs_to :user
  validates :title, :company, :post_date, :description, presence: true

  def logo_validator(url)
    res = Faraday.get("https://logo.clearbit.com/#{url}")
    unless res.status == 200
      "https://placeholdit.imgix.net/~text?txtsize=33&txt=400%C3%97400&w=400&h=400"
    else
      "https://logo.clearbit.com/#{url}"
    end
  end

end

class User < ActiveRecord::Base
  has_attached_file :document
  validates_attachment :document, :content_type => { :content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document) }

  validates :first_name, :last_name, :email, :phone_number, presence: true
  validates :username, uniqueness: true
  has_many :jobs
  has_secure_password

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']
  has_attached_file :pdf,
  :storage => :s3,
  :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
  :path => "/userpdfs/:id/:basename.:extension"

  validates_attachment_content_type :pdf, :content_type => ['application/pdf', 'application/msword', 'text/plain'], :if => :pdf_attached?

  def pdf_attached?
    self.pdf.file?
  end
end

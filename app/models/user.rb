class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable

  validates :email, format: URI::MailTo::EMAIL_REGEXP, uniqueness: true
  validates :password, confirmation: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :first_name, uniqueness: { scope: :last_name }

  validates :gender, inclusion: { in: %w[F M] }
  validates :activity_type, inclusion: { in: %w[sedentary lightly_active moderately_active active very_active] }
  validates :height, numericality: true, allow_blank: true
  validates :weight, numericality: true, allow_blank: true
  validates :date_of_birth, timeliness: { on_or_before: lambda { Date.current }, type: :date }, allow_blank: true

  # the authenticate method from devise documentation
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  def compute_amr
    return if height.blank? || weight.blank? || date_of_birth.blank?

    if male?
      bmr = 655.1 + (9.563 * weight) + (1.850 * height) - (4.676 * age)
    else
      bmr =  66.47 + (13.75 * weight) + (5.003 * height) - (6.755 * age)
    end

    factor = case activity_type
             when 'sedentary'
               1.2
             when 'lightly_active'
               1.375
             when 'moderately_active'
               1.55
             when 'active'
               1.725
             when 'very_active'
               1.9
             end
    amr = bmr * factor
    self.update_attribute(:active_metabolic_rate, amr)
  end

  def male?
    gender == 'M'
  end

  def female?
    gender == 'F'
  end

  def age
    now = Date.current
    now.year - date_of_birth.year -
      ((now.month > date_of_birth.month ||
        (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
  end
end

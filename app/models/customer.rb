class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :cart_products, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true
  validates :first_name_kana, presence: true
  validates :postal_code, presence: true
  validates :address, presence: true
  validates :telephone_number, presence: true
  validates :email, presence: true

  def customer_address_set
    self.postal_code + self.address
  end

  def customer_full_name
    self.last_name + self.first_name
  end

  def active_for_authentication?
        super && (self.is_deleted === false)
  end

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.first_name = "ゲスト"
      customer.last_name = "ユーザー"
      customer.first_name_kana = "ゲスト"
      customer.last_name_kana = "ユーザー"
      customer.postal_code = SecureRandom.urlsafe_base64
      customer.telephone_number = SecureRandom.urlsafe_base64
      customer.address = SecureRandom.urlsafe_base64
    end
  end

end
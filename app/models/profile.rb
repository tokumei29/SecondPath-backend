class Profile < ApplicationRecord
  validates :user_id, presence: true, uniqueness: true

  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.strengths = [ "", "", "" ] if strengths.blank?
    self.weaknesses = [ "", "", "" ] if weaknesses.blank?
    self.likes = [ "", "", "" ] if likes.blank?
    self.hobbies = [ "", "", "" ] if hobbies.blank?
    self.short_term_goals = [ "", "", "" ] if short_term_goals.blank?
    self.long_term_goals = [ "", "", "" ] if long_term_goals.blank?
  end
end

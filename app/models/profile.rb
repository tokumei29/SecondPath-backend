class Profile < ApplicationRecord
  validates :user_id, presence: true, uniqueness: true

  after_initialize :set_defaults, if: :new_record?

  private

  def set_defaults
    self.strengths ||= [ "", "", "" ]
    self.weaknesses ||= [ "", "", "" ]
    self.likes ||= [ "", "", "" ]
    self.hobbies ||= [ "", "", "" ]
    self.short_term_goals ||= [ "", "", "" ]
    self.long_term_goals ||= [ "", "", "" ]
  end
end

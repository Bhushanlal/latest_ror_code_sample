class ProblemsetQuestion
  include Mongoidal::RootDocument
  include Mongoid::Attributes::Dynamic
  include Permittable
  include Mongoid::Paranoia

  store_in collection: "questions"

  belongs_to :problem_set
  has_many :answers, foreign_key: "question_id", inverse_of: :problemset_questions

  admin_permitted :problem_set_id
  admin_permitted field :question, type: String
  admin_permitted field :tags, type: Array
  admin_permitted field :rank, type: Integer
  admin_permitted field :position, type: Integer
  admin_permitted field :help, type: String
  admin_permitted field :help_exp, type: String
  admin_permitted field :question_exp, type: String
  admin_permitted field :exp_position_before_answer, type: Boolean, default: true # to show question explationation before answers 
  admin_permitted field :question_type, type: String
  admin_permitted field :is_math, type: Boolean, default: false
  admin_permitted field :is_free_response, type: Boolean, default: false

  # Only useful on Math questions
  # Should figure out how to implement dynamic fields going forward
  admin_permitted field :is_calc, type: Boolean, default: false
  admin_permitted field :is_hidden, type: Boolean, default: false

  # This does not work since the string is a DraftJS immutable
  # validates :question, length: {minimum: 1}
  after_remove :delete_associated_data
  after_create do
    self.is_math = true
    self.save!
  end

  def delete_associated_data
    answers.destroy_all
  end
end
  
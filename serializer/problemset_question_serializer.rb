class ProblemsetQuestionSerializer < ActiveModel::Serializer
  attributes :id, :problem_set_id, :question, :tags, :rank, :position,
  :help, :help_exp, :question_exp, :total_answers, :total_unlinked_answers,
  :is_math, :is_calc, :is_free_response, :exp_position_before_answer, :is_hidden

  def total_answers
    object.answers.count
  end

  def total_unlinked_answers
    object.answers.where(next_question: nil).count
  end
end
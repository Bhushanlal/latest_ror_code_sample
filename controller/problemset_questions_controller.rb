class Api::ProblemsetQuestionsController < ApplicationController
  before_action :require_admin_user!, only: [:create, :update, :destroy]
  before_action :require_authorized!, only: [:index, :show]

  def index
    if params[:problem_set_id]
      query = params[:problem_set_id]
      result = klass.where(problem_set_id: query).order_by(position: :asc)
    else
      result = klass.all.order_by(position: :asc)
    end
    render json: result
  end

  def create
   render json: klass.create!(data_params)
  end

  def show
    render json: klass.find(params[:id])
  end

  def update
    existing_problemset_question.assign_attributes(data_params)
    existing_problemset_question.save!
    render json: existing_problemset_question
  end

  def destroy
    problemset_question = existing_problemset_question
    existing_problemset_question.destroy
    render json: problemset_question
  end

  def update_positions
    new_arr = []
    problemset_data = params["data"]
    problemsets = problemset_data #problemset_data['problem_sets']
    problemsets.each_with_index { |el, idx|
      problemset = klass.find(el[:id])
      problemset[:position] = idx
      problemset.save!
      new_arr.push(problemset)
    }

    render json: new_arr
  end

  def get_problemset_questions
    data = params["data"]
    questions = ProblemsetQuestion.where(:problem_set_id.in => data["problem_set_id"])
    render json: questions
  end

  protected

  def existing_problemset_question
    @existing_problemset_question||= klass.find(params[:id]) if params[:id]
  end

  def data_params
    params.require('data').permit(*klass.permitted_fields)
  end

  def klass
    ProblemsetQuestion
  end
end
  
class InstructorsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid,
              with: :render_unprocessable_entity_error

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

  def index
    render json: Instructor.all
  end

  def show
    instructor = Instructor.find_by(id: params[:id])
    if instructor
      render json: instructor
    else
      render json: { error: "Not found" }, status: :not_found
    end
  end

  def create
    instructor = Instructor.create!(instructor_params)
    render json: instructor
  end

  def update
    instructor = Instructor.find_by(id: params[:id])
    if instructor
      instructor.update!(instructor_params)
      render json: instructor
    else
      render json: { error: "Not found" }, status: :not_found
    end
  end

  def destroy
    instructor = Instructor.find_by(id: params[:id])
    if instructor
      instructor.destroy
      head :no_content
    else
      render json: { error: "Not found" }, status: :not_found
    end
  end

  private

  def instructor_params
    params.permit(:name)
  end

  def render_unprocessable_entity_error(exception)
    render json: {
             errors: exception.record.errors.full_messages
           },
           status: :unprocessable_entity
  end

  def render_not_found_error
    render json: { error: "Not found" }, status: :not_found
  end
end

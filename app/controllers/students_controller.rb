class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid,
              with: :render_unprocessable_entity_error

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

  def index
    render json: Student.all
  end

  def show
    student = Student.find_by(id: params[:id])
    if student
      render json: student
    else
      render json: { error: "Not found" }, status: :not_found
    end
  end

  def create
    if params[:instructor_id]
      student = Student.create!(student_params)
      render json: student
    else
      render json: {
               error: "Needs an instructor"
             },
             status: :unprocessable_entity
    end
  end

  def update
    student = Student.find_by(id: params[:id])
    if student.instructor_id
      if student
        student.update!(student_params)
        render json: student
      else
        render json: { error: "Not found" }, status: :not_found
      end
    else
      render json: {
               error: "Needs an instructor"
             },
             status: :unprocessable_entity
    end
  end

  def destroy
    student = Student.find_by(id: params[:id])
    if student
      student.destroy
      head :no_content
    else
      render json: { error: "Not found" }, status: :not_found
    end
  end

  private

  def student_params
    params.permit(:name, :age, :major, :instructor_id)
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

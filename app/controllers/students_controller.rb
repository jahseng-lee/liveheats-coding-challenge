class StudentsController < ApplicationController
  def index
    # NOTE: this could be done in a serializer or "Query" object
    #       but simple enough for now in the controller
    @students = Student
      .all
      .map do |student|
        {
          id: student.id,
          name: student.name
        }
      end

    render json: { students: @students }
  end
end

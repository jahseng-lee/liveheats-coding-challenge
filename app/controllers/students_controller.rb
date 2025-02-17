class StudentsController < ApplicationController
  def index
    # NOTE: this could be done in a serializer or "Query" object
    #       but simple enough for now in the controller
    @students = Student
      .pluck(:id, :first_name, :last_name)
      .map do |student|
        {
          id: student[0],
          first_name: student[1],
          last_name: student[2]
        }
      end

    render json: { students: @students }
  end
end

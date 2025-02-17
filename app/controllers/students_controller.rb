class StudentsController < ApplicationController
  def index
    # NOTE: this could be done in a serializer or "Query" object
    #       but simple enough for now in the controller
    @students = Student
      .pluck(:id, :first_name, :last_name)
      .map do |student|
        {
          id: student[0],
          # "first_name last_name"
          name: [student[1], student[2]].join(" ")
        }
      end

    render json: { students: @students }
  end
end

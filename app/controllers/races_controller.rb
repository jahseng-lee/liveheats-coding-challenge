class RacesController < ApplicationController
  class NotEnoughParticipantsError < StandardError; end
  class DuplicateLaneError < StandardError; end
  class DuplicateParticipantError < StandardError; end

  def create
    @race = Race.new(name: race_params[:name])

    Race.transaction do
      if not_enough_participants?(params: race_params)
        raise NotEnoughParticipantsError,
          "not enough participants in the race"
      end
      if duplicate_lanes?(params: race_params)
        raise DuplicateLaneError,
          "multiple participants assigned to the same lane"
      end
      if duplicate_participants?(params: race_params)
        raise DuplicateParticipantError,
          "participant assigned to multiple lanes"
      end

      @race.save!

      race_params[:participants].each do |participant|
        @race.participants.create!(
          student_id: participant[:student_id],
          lane: participant[:lane],
          race: @race
        )
      end
    end

    render json: {}, status: 201
  rescue NotEnoughParticipantsError
    render json: {
      message: "Have to have 2 or more participants in the race"
    }, status: 422
  rescue DuplicateLaneError
    render json: {
      message: "Can't assign multiple students to a single lane"
    }, status: 422
  rescue DuplicateParticipantError
    render json: {
      message: "Can't assign a single participant to multiple lanes"
    }, status: 422
  end

  private

  def race_params
    params.require(:race).permit(
      :name,
      participants: [
        :student_id,
        :lane
      ]
    )
  end

  def not_enough_participants?(params:)
    params[:participants].length < 2
  end

  def duplicate_lanes?(params:)
    race_params[:participants].map{ |participant| participant[:lane] }.count !=
      race_params[:participants].map{ |participant| participant[:lane] }.uniq.count
  end

  def duplicate_participants?(params:)
    race_params[:participants].map{ |participant| participant[:student_id] }.count !=
      race_params[:participants].map{ |participant| participant[:student_id] }.uniq.count
  end
end

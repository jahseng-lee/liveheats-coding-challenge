class RacesController < ApplicationController
  class NotEnoughParticipantsError < StandardError; end
  class DuplicateLaneError < StandardError; end
  class DuplicateParticipantError < StandardError; end

  def index
    @races = Race
      .order(created_at: :desc)
      .pluck(:id, :name, :status)

    render json: {
      status: 200,
      races: @races.map do |race|
        {
          id: race[0],
          name: race[1],
          status: race[2]
        }
      end
    }, status: 200
  end

  def show
    @race = Race.find(params[:id])

    render json: {
      status: 200,
      race: {
        id: @race.id,
        name: @race.name,
        participants: @race.participants.map do |participant|
          {
            id: participant.id,
            name: participant.student.name,
            lane: participant.lane,
            placing: participant.placing
          }
        end
      }
    }
  end

  def create
    @race = Race.new(name: race_params[:name])

    Race.transaction do
      if not_enough_participants?
        raise NotEnoughParticipantsError,
          "not enough participants in the race"
      end
      if duplicate_lanes?
        raise DuplicateLaneError,
          "multiple participants assigned to the same lane"
      end
      if duplicate_participants?
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

    render json: { status: 201 }, status: 201
  rescue NotEnoughParticipantsError
    render json: {
      status: 422,
      message: "Have to have 2 or more participants in the race"
    }, status: 422
  rescue DuplicateLaneError
    render json: {
      status: 422,
      message: "Can't assign multiple students to a single lane"
    }, status: 422
  rescue DuplicateParticipantError
    render json: {
      status: 422,
      message: "Can't assign a single participant to multiple lanes"
    }, status: 422
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      status: 422,
      message: e.record.errors.full_messages,
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

  def not_enough_participants?
    race_params[:participants].map do
      |participant| participant[:student_id]
    end.compact.length < 2
  end

  def duplicate_lanes?
    race_params[:participants].map{ |participant| participant[:lane] }.count !=
      race_params[:participants].map{ |participant| participant[:lane] }.uniq.count
  end

  def duplicate_participants?
    race_params[:participants].map{ |participant| participant[:student_id] }.count !=
      race_params[:participants].map{ |participant| participant[:student_id] }.uniq.count
  end
end

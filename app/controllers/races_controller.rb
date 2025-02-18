class RacesController < ApplicationController
  class DuplicateLaneError < StandardError; end
  class DuplicateParticipantError < StandardError; end
  class NotEnoughParticipantsError < StandardError; end
  class PlacementGapsError < StandardError; end
  class RaceAlreadyCompleteError < StandardError; end

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
        status: @race.status,
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
    @race = Race.new(name: create_race_params[:name])

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

      create_race_params[:participants].each do |participant|
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

  def update
    @race = Race.find(params[:id])

    if placing_gaps?
      raise PlacementGapsError, "gaps in final placings"
    end
    if @race.complete?
      raise RaceAlreadyCompleteError, "race is already complete"
    end

    Race.transaction do
      update_race_params[:participants].each do |participant|
        @race
          .participants
          .find(participant[:id])
          .update!(
            placing: participant[:placing]
          )
      end

      @race.update!(status: "complete")
    end

    render json: { status: 201 }, status: 201
  rescue PlacementGapsError
    render json: {
      status: 422,
      message: "Placements invalid. Placements must have correct gaps" \
        " i.e. \"1, 1, 3, 4\"; NOT \"1, 1, 2, 4\" OR \"1, 3, 4, 6\""
    }, status: 422
  end

  private

  def create_race_params
    params.require(:race).permit(
      :name,
      participants: [
        :student_id,
        :lane
      ]
    )
  end

  def update_race_params
    params.require(:race).permit(
      participants: [
        :id,
        :placing
      ]
    )
  end

  def not_enough_participants?
    create_race_params[:participants].map do
      |participant| participant[:student_id]
    end.compact.length < 2
  end

  def duplicate_lanes?
    create_race_params[:participants].map{ |participant| participant[:lane] }.count !=
      create_race_params[:participants].map{ |participant| participant[:lane] }.uniq.count
  end

  def duplicate_participants?
    create_race_params[:participants].map{ |participant| participant[:student_id] }.count !=
      create_race_params[:participants].map{ |participant| participant[:student_id] }.uniq.count
  end

  # Simple algorithm to detect placing gaps
  # [1, 2, 3] is valid, will return false
  # [1, 1, 3] is valid, will return false
  # [1, 1, 2] is invalid, will return true
  # [1, 2, 4] is invalid, will return true
  # [1, 2, nil] is invalid, will return true
  def placing_gaps?
    sorted_placings = update_race_params[:participants]
      .map do |participant|
        if participant[:placing].nil?
          # Don't allow `nil`
          return true
        end

        Integer(participant[:placing])
      end
      .sort

    current_placing = 1
    next_valid_placing = 1
    sorted_placings.each do |placing|
      if placing != current_placing &&
          placing != next_valid_placing
        # placing is not a tie not the next expected placing
        return true
      end

      current_placing = placing
      next_valid_placing += 1
    end

    false
  end
end

class Api::StatusController < ApplicationController
  def index
    redis_state = false
    db_state = false
    begin
      redis_state = $redis.ping == 'PONG'
    rescue
      redis_state = false
    end
    begin
      ActiveRecord::Base.connection
      db_state = ActiveRecord::Base.connected?
    rescue
      db_state = false
    end
    render json: {
      db_state: db_state,
      redis_state: redis_state
    }
  end
end

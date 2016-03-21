class Application::LogsController < ApplicationController
  def show
    @ship = Ship.find_by!(name: params[:ship_name])
    self.response_body = Enumerator.new do |y|
      swarm_client.stream_logs(@ship) do |l|
        y << l
      end
    end
  end

  private
  def swarm_client
    SwarmClient.new
  end
end

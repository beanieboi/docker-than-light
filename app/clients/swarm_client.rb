require 'docker'
class SwarmClient
  class NotFound < StandardError; end
  DEFAULT_PORT = "8080/tcp"
  def stream_logs(ship, &block)
    container(ship.container_id).streaming_logs(stdout: true) { |stream, chunk| yield "#{stream}: #{chunk}" }
  end

  def create_ship(ship)
    Docker::Image.create('fromImage' => ship.image)
    if ship.container_id.nil?
      container = Docker::Container.create('Image' => ship.image,
                                           'Hostname' => ship.name,
                                           'Env' => [
                                             "SHIP_NAME=#{ship.name}",
                                             "TOKEN=#{ship.token}",
                                             "API_URL=#{ENV['API_URL']}",
                                           ],
                                           'ExposedPorts' => {
                                             DEFAULT_PORT => {}
                                           })
      container.start({ 'PortBindings' => {DEFAULT_PORT => [{"HostPort" => ""}]}})
      ship.update_attribute(:container_id, container.id)
      json = container.json
      addr = json["Node"]["Addr"]
      parts = addr.split(":")
      ship.update_attribute(:source, parts.first)
      ship.update_attribute(:port, parts.last)
    end
  end

  def destroy_ship(ship)
    container(ship.container_id).delete(:force => true)
    ship.update_attribute(:container_id, nil)
    ship.update_attribute(:source, nil)
  end

  private

  def container(id)
    raise NotFound.new unless id
    container = Docker::Container.get(id)
    if container.nil?
      raise NotFound.new
    end
    return container
  end
end

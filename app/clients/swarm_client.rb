require 'docker'
class SwarmClient 
  class NotFound < StandardError; end
  DEFAULT_PORT = "80/tcp"
  def stream_logs(ship)
    # just dump out logs for now
    container(ship.container_id).streaming_logs(stdout: true) { |stream, chunk| puts "#{stream}: #{chunk}" }
  end

  def create_ship(ship)
    Docker::Image.create('fromImage' => ship.image)
    if ship.container_id.nil?
      container = Docker::Container.create('Image' => ship.image, 
                                           'Hostname' => ship.name,
                                           'Env' => [ 
                                             "SHIP_NAME=#{ship.name}",
                                             "API_URL=#{ENV['API_URL']}",
                                           ], 
                                           'ExposedPorts' => {
                                             DEFAULT_PORT => {}
                                           })
      container.start({ 'PortBindings' => {DEFAULT_PORT => [{"HostPort" => ""}]}})
      ship.update_attribute(:container_id, container.id)
      json = container.json
      addr = json["NetworkSettings"]["IPAddress"]
      port = json["NetworkSettings"]["Ports"][DEFAULT_PORT].first["HostPort"]
      ship.update_attribute(:source, addr)
      ship.update_attribute(:port, port)
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

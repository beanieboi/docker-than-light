require 'docker'
class SwarmClient 
  class NotFound < StandardError; end
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
                                             "80/tcp" => {}
                                           })
      container.start({ 'PortBindings' => {"80/tcp" => [{"HostPort" => ""}]}})
      ship.update_attribute(:container_id, container.id)
      json = container.json
      addr = json["NetworkSettings"]["IPAddress"]
      ship.update_attribute(:source, addr)
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

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
                                           },
                                           'HostConfig' => {
                                             'NetworkMode' => ship.sector.name,
                                             'PublishAllPorts' => true
                                           })
      container.start({ 'PortBindings' => {DEFAULT_PORT => [{"HostPort" => ""}]}})
      ship.update_attribute(:container_id, container.id)
      set_initial_network(ship, ship.sector)
      json = container.json
   
      network_info = json["NetworkSettings"]["Ports"][DEFAULT_PORT].first
      source = network_info["HostIp"]
      port = network_info["HostPort"]
      ship.update_attribute(:source, source)
      ship.update_attribute(:port, port)
    end
  end

  def destroy_ship(ship)
    container(ship.container_id).delete(:force => true)
    ship.update_attribute(:container_id, nil)
    ship.update_attribute(:source, nil)
  end

  def create_network(sector)
    Docker::Network.create(sector.name)
  end

  def delete_network(sector)
    Docker::Network.remove(sector.network_id)
  end

  def set_initial_network(ship, sector)
    bridge = Docker::Network.all.select {|n| n.info['Name'] == "bridge"}.first
    if bridge
      bridge.disconnect(ship.container_id)
    end
    new_net = network(sector.network_id)
    new_net.connect(ship.container_id)
  end

  def switch_network(ship, old_sector, new_sector)
    old_net = network(old_sector.network_id)
    new_net = network(new_sector.network_id)
    begin
      old_net.disconnect(ship.container_id)
    rescue Docker::Error::ServerError => e
      raise e unless e.message =~ /is not connected to the network/
    end
    new_net.connect(ship.container_id)
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

  def network(id)
    raise NotFound.new unless id
    network = Docker::Network.get(id)
    if network.nil?
      raise NotFound.new
    end
    return network
  end
end

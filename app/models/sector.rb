class Sector < ActiveRecord::Base
  has_many :ships

  before_create :create_network
  before_destroy :delete_network
  private

  def create_network
    if network_id == nil
      network = swarm_client.create_network(self)
      self.network_id = network.id
    end
  end

  def delete_network
    if network_id
      swarm_client.delete_network(self)
      update_attribute(:network_id, nil)
    end
  end

  def swarm_client
  	SwarmClient.new
  end
end

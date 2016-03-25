class Sector < ActiveRecord::Base
  has_many :ships

  after_create :create_network
  before_destroy :delete_network
  private

  def create_network
    swarm_client.create_network(self)
  end

  def delete_network
    swarm_client.delete_network(self)
  end

  def swarm_client
  	SwarmClient.new
  end
end

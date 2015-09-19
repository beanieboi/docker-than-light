## Setup
To get set up with this project you'll need a couple of things

1. [Docker experimental](https://github.com/docker/docker/tree/master/experimental)
2. [Docker machine](https://docs.docker.com/machine/install-machine/)
3. [calicoctl binary](https://github.com/projectcalico/calico-docker/releases/tag/v0.6.0)

First lets create a swarm, run `create_swarm.sh` and it'll set you up with a simple local swarm with two nodes.

Next scp calicoctl to each swarm node, and run it:

```
docker-machine scp calicoctl swarm-master:
docker-machine scp calicoctl swarm-agent-00:
docker-machine scp calicoctl swarm-agent-01:
docker-machine ssh swarm-master sudo ./calicoctl node --libnetwork
docker-machine ssh swarm-master sudo ./calicoctl node --libnetwork
docker-machine ssh swarm-master sudo ./calicoctl node --libnetwork
```

Finally you'll be able to create containers on specific networks:

```
docker run --publish-service srvA.net1.calico --name workload-A -tid busybox
docker run --publish-service srvB.net2.calico --name workload-B -tid busybox
docker run --publish-service srvC.net1.calico --name workload-C -tid busybox
```

In this example workload A and C cannot communicate with workload B.

## Clients

Please see https://github.com/beanieboi/docker-than-light-clients

## Summary
This project is basically a simple, multiplayer, ai driven version of ftl, elite, eve, [insert space game here]. The idea is that we can draw a clear analogy between containers distributed across a cluster, with ships within a sector of space. The goal here is to make something fun that demonstrates the principles of isolation of containers, as well as the portability of applications within containers.

Each container represents an entity within the game world, be that a player ship, a station, a harvestable resource, an ai enemy or random encounter. These entities interact via a mediator, essential a syncing God api present in each sector. This api tracks state within each entity, and approves or denies actions each entity request. An example would be a ship tries to fire upon another ship, however has insufficient energy. The ship submits a fire request to the God api, the God api denies the request based on the fact the ship does not have sufficient energy. This prevents users submitting actions beyond their capability. Should a fire request be successful, the God api would then forward the fire request as a hit notification to the relevant party, which knows and trusts the God api.

##Sectors
One of the basic notions is the idea of a sector, each sector represents a logical space, connected (randomly?) to other logical spaces. With sufficient energy, entities can request to travel to other sectors, at which point the God api negotiates transfer to another sector. The simplest logical separation is the host, i.e. a container moves sectors by switching hosts, however a much better solution would be to use docker network plugins private networks. It’s pretty trivial to move a container between networks, and then each sector becomes infinitely scalable, rather than the mess Eve online is.

##Ships
I considered making it so users could directly control ships, however it becomes far less of a UI burden to simply make each ship be controlled by player written AI. See screeps as a cool example of a game like this. One of the biggest challenges in a game like this is providing a common scripting language or dsl. Containerization instantly solves this for us, since each container runs in complete isolation. We don’t have to care what language is used, as long as it conforms to a specified API, we can interact. This means the entire game also becomes an exercise in microservices and rest apis.

We can write a set of basic containers in different languages to do simple actions in different languages, such as if someone fires at you or does something hostile, just leave. The ai within ships will be a mixture of responding to events, such as you were fired at, or another ship, and polling, such as scanning certain ships, initiating firing based on energy levels. We’ll have to consider memory and cpu restrictions per container and possibly rate limiting.

Users will be able to interact with everything via the God api, and potentially also directly. This would allow for a certain amount of spoofing as people could take advantage of enemies who don’t verify that the hit notification came from the God api, and manage to confuse or overload enemy AI with other information.

##Requirements
###Infrastructure

This requires the following

- A docker cluster (local docker-machine should work for us, maybe something hosted if we demo)
- One of the docker network plugins, preferably weave or calico, leaning towards weave as it’s a little easier to integrate

###Controller
We need a component (the God api) to mediate actions, remove destroyed containers, forward logs and events and create new spawns.

###UI
We’ll need a ui on top of the controller to handle admin actions and provide an interface for users to submit new spawns and view status, logs of their ship, as well as other info about the state of different sectors. This layer should isolate users from being able to fiddle with the controller, or inject their own spawns.
###Samples
We’ll need to provide a few examples of basic ships, maybe in different languages with skeletal api implementations

- Scared ship that leaves a sector as soon as a ship appears
- Aggressive ship that searches through sectors for other ships and attacks
- Defensive ship that holds position, and returns fire, and runs if damaged

###The Game
So the purpose of the game is to stay alive. You your ship has a shield and a hull as well as a primary weapon. It also has a re-generating energy reserve which is used to recharge the shield, fire the weapon and travel between sectors.

When a ship is created, the creator can re-balance max shield, recharge rate, energy reserve, recharge rate, fire rate, weapon damage, accuracy, and stealth. These factors come into play when maneuvering and can greatly affect the outcome of a battle. We will fully disclose the details of how these affect battle mechanics, and the equations used which will allow users to allocate their resources should they wish. The God api will be the source of truth for simulating ship resources.

After killing an enemy a ship is awarded scrap, which can be used to upgrade ships systems, or repair the hull. We could make this be a cargo mechanic where scrap is taken to a station and once the ship is docked there, they can exchange the scrap. Cargo space would then also be a factor and a ship may not be able to take all scrap from a battle.

Similarly we could have asteroids and nebula ships can invest time in harvesting resources from to exchange for upgrades, a good upgrade path for weak or defensive ships. We could also allow for torpedos which are not rechargeable but do a lot more damage, and are bought with resources.

###Ships
A ship can be run by any container, provided it adheres to a specific API. If any API call from the God api fails (gets a 404, connection timeout or non allowed reply) the ship will take damage. Once the ships health reaches zero, the God api will send a sigterm with a 5 second timeout. This timeout represents the time it takes the ship to break apart, and can be used to discharge the remaining torpedos and weaponry, providing the God api will allow it.

Each ship must adhere to a versioned api schema, which must be well documented and extended as new features are added:

####Ship API
GET /_ping
must always return 200. God api uses this as a keepalive.

POST /message
Any text posted to this api comes from another ship. This will primarily be used for taunting, but could be used to do some complex coordination in the future, and potentially automated team work of a users mutliple ships. This must always return any status code with an optional response.

POST /action
The action api is the primary entrypoint for activity notifications against a ship from other ships. This is an extensible entrypoint which allows a user to effectively ignore actions it does not care about, or wants to reject. The api must accept the connection and return any response code. This will include the following possible payloads

- { “type” : “hit”, “payload”: { “damage”: 10, “enemy”: IP}, “state”: {NEW_SHIP_STATE}}
- { “type” : “scan”, “payload”: { “enemy”: IP}, “state”: {NEW_SHIP_STATE}}

POST /update
API used by the God api to update the simulated state of the ship as it sees fit to counter clock drift, rounding errors, user error etc. This request should replace a ships understanding of its state. An api call does not necessarily denote any activity, purely a sync.
God API
The God API is the api the ships use to negotiate state change. No action a ship takes is valid unless the God controller confirms it.

POST /fire/IP
The God controller will use the source IP to determine where the shot came from, ensure the user can afford the shot, ensure the target is still in the sector, confirm the shot, notify the target of a hit and return a 200 for success, maybe a 404 for a miss, and maybe a 400/422 if the target has left or the ship has insufficient energy.

GET /scan/
This returns a list of all entities in the sector, and their IPs (excluding the source of course)

GET /scan/IP
Scans an enemy ship, returning energy levels, hull. other info maybe? Whether this succeeds is determine by stealth.

POST /upgrade/type
Depending on how many resources a ship has from conquest, it can request an upgrade of a specific ships system (maybe in blocks of 10 to simplify the api?). The types are all based on the basic ship stats.

GET /sectors/
This returns a list of all connected sectors

POST /travel/SECTOR_NAME
When a ship wants to travel they simply make a post request. The God API will accept it and return a 200 if they have the energy for it. They will then be moved to another private network in that sector, and can no longer connect to the previous ships in the previous sector.

Controller
So the controller is responsible for handling ship state, and facilitation battle, travel, etc. Every action costs time and energy, and the controller must ensure ships have the energy needed or reject the request. All requests for each ship must be serialized to ensure the ship is perform actions in a series. Since the controller facilitates travel, it needs have access to the weave controller as well as a full understanding of the available sectors and the private networks representing them.

##MVP

The basic mvp we need consists of the following features

- UI
  - A user can provide a docker container url and a name, and spawn a ship.
  - A user that spawns a ship is provided with a unique url where they can monitor their ships process

  - Each user is prohibited from creating multiple ships (teaming) by cookies? or possibly IP detection? Eventually login. There is still a change users will team up using standard naming schemas to identify friendly ships, but there is also a chance other users will take advantage of this.
  - Using the url the user can view logs from their ship, as well as activity in different sectors (but not other ships logs) provided by the God api.

- Infrastructure

  - We need a docker swarm with weave/calico (pref weave)

- Controller
  - When a UI request comes in for a new ship spawn the controller selects a sector, pulls the image, and starts the container
  - Controller allows a ship to redistribute its allocation of points once
  - Controller periodically syncs its simulated ship state with the ship
  - Controller provides the God API allowing ships to interact
  - Controller mediates ship state change and forwards notifications between ships
  - Controller aggregates logs for specific users containing their ships output, but also sector events from their sector
  - Controller has access to the weave controller and can create networks and move containers between networks

### Advanced features
- UI
  - A gui...nom
  - user logins
  - user stats
  - history
- Game
  - cargo space
  - stations
  - harvestable resources
  - complex ship stats


### A typical flow would be something like this
- Ship spawns
- Scan
- If ships, attack
- If shield gets low, flee
- Travel to new sector
- Charge to full shield and energy
- Run if attacked
- Upgrade if victorious
- Repeat

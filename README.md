## Docker-than-light

Docker-than-light is a mulitplayer docker container game. It consists of a rails app controlling a docker cluster in a simple FTL inspired space game. Each container represents a ship, and interacts with other ships and the game world via standardized REST APIs. Each ship is essentially a microservice running in a docker container. 

The rules of the game are simple at this stage, but could be expanded in the future. Each ship has 100 energy which charges at a rate of 10 per seconds. This energy is used to scan the sector for other neighboring sectors as well as other ships, or to travel to other sectors. It can also be spent on firing on other ships. Each ship has limitied non-rechargeable shield which when it reaches zero will result in the ship (and container) being destroyed.

The rails application manages this interaction. Each ship can be an application written in any language. The concept is similar to other AI based programming games, however due to the utilization of docker containers, we have access to any possible language. We have purposefully left the game relatively open so that users can generate truly unique experiences. In the future we fully expect users to create GUIs to manually connect to and control ships, complex learning applications, hacking via the network layer, as well as highly intelligent traditional AI containers.

### Example

Using the defensive example container (which runs upon seeing an enemy), and the aggresive one (which chase enemies), here is an example of the interaction between the two containers:

```
# Defensive
Starting..
Scanning...
Selected escape sector A
ALERT! Detected Ship, evac!!!
Evaccing to A
Scanning...
Selected escape sector B
Scanning...
Selected escape sector B
ALERT! Detected Ship, evac!!!
Evaccing to B
Scanning...
Selected escape sector A
ALERT! Detected Ship, evac!!!
Evaccing to A
Scanning...
Selected escape sector B
``` 

```
# Aggresive
Starting..
Scanning...
Travelling to A
Failed to travel: Travel failed!
Scanning...
Travelling to A
Scanning...
Selected target ship scardycat1
Fixing on scardycat1
Fail!
Failed to attack scardycat1, Fire failed!
Scanning...
Travelling to B
Scanning...
Selected target ship scardycat1
Fixing on scardycat1
HIT!
Fixing on scardycat1
HIT!
Fixing on scardycat1
Fail!
Failed to attack scardycat1, Fire failed!
Scanning...
Unable to scan: Scan failed!
Scanning...
Travelling to A
Scanning...
Selected target ship scardycat1
Fixing on scardycat1
```

Probability comes into play with each attempt, so not all firing or travelling attempts will succeed. 


### Getting started

To try this out you will need the following

* Docker 
* docker-than-light rails app
* a chosen docker-than-light-clients client

First run the rails migrations and the server with the following environment variables:

```
API_URL=http://192.168.29.230:3000 #URL for the rails server
DOCKER_URL=$DOCKER_HOST #URL for your docker instance
```

From here you can create ships in the docker cluster by visiting the app in the browser, or using the console to create ships with Ship.create, specifying a name and initializing the basic values.

From here a container will be created on your docker instance. By viewing the logs you can see activity.

Make sure your API_URL is routable from your docker containers. 

### The future

The original intention was to use calico networks as logical sectors and have a pure isolated but hackable network between ships within a sector, however that was much too difficult for the short time we had.

We also see this as being a natural fit for a swarm cluster, since we're using logical sectors, however again, swarm clusters require a more complex implementation.

There are also many improvements we want to make to the APIs, including adding features, documentation, error handling. Beyond that the game itself could be far more interesting witht the concept of cargo, reward and upgrades, healing, communication and trade.

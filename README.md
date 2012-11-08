## Simcity App

This project houses the bits of the simcity project that aren't solely concerned
with simulation.  Where `simcity` is just the simulation of the various
components, `simcity_app` aims to be the part that layers in a few
'game-specific' concepts.  Namely:

- Session
  - This is where the concept of 'remaining money' and 'accruing money' resides.
- Cost
  - This is a layer that maps each structure to a given cost.
- Some additional bits of API
  - This is the layer that the server should be interacting with.  It will house
    a running simulation, and it will use the same concepts (tick, etc) to
    handle the interaction.

Each tick, a session will accrue a certain amount of money.  There will be a
public api to add a given structure of a given type.  The API will fail if there
isn't sufficient money to perform the action.

### API Usage Examples

#### Create a Session
In order to instantiate the API, you start a new session and specify the map
size.  This works just like creating a new map, but houses some more concepts
internally.

    @session = Simcity::Session.new(10, 10)

#### Tick the Session
In order to gain cash and advance the map, just call `#tick`.  This will do the
session's loop, as well as advance the simulation one tick.

    @session.tick

#### Check the currently available cash
The session knows how much cash has accrued:

    @session.cash
    #=> BigDecimal('0')
    @session.tick
    @session.cash
    #=> BigDecimal('0.1')

#### Build a given object at a certain point
This will first create the structure, then deduct the appropriate amount of
cash.

    # Assuming a PowerPlant costs 150
    @session.cash
    #=> BigDecimal('200')
    @session.insert_object(Map::Point.new(x, y), PowerPlant)
    @session.cash
    #=> BigDecimal('150')

#### The map is available from the session
To get at the underlying simulation, you can just reference the `#map`

    @session.map
    #=> <Map 10, 10>

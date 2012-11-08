module Simcity
  class Session
    attr_reader :map, :cash

    def initialize(width, height)
      @map = Map.new(width, height)
      @cash = BigDecimal('0')
    end

    def tick
      increment_cash!
      @map.tick
    end

    def insert_object(point, klass)
      @map.cell_at(point) << klass.new(@map)
      cost = cost_for_class(klass)
      @cash -= cost
    end

    def cost_for_class(klass)
      cost_mappings[klass]
    end

    private
    def increment_cash!
      @cash += cash_increment
    end

    # This determines how much we increment by each tick
    def cash_increment
      BigDecimal('0.1')
    end

    def cost_mappings
      {
        House => BigDecimal('50'),
        Structure::Road  => BigDecimal('10'),
        PowerPlant => BigDecimal('100'),
        WaterPump => BigDecimal('100'),
        GarbageDump => BigDecimal('100')
      }
    end
  end
end

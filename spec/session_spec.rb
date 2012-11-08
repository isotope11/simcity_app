require 'spec_helper'

describe Session do
  subject{ Session.new(10, 10) }

  it "has an underlying #map" do
    subject.map.should be_a(Simcity::Map)
  end

  it 'knows about #cash' do
    subject.cash.should == BigDecimal('0')
  end

  context 'ticking' do
    before do
      subject.map.should_receive(:tick)
    end

    it 'can be #tick-ed' do
      subject.tick
    end

    it 'accrues cash each #tick' do
      subject.tick
      subject.cash.should == BigDecimal('0') + subject.send(:cash_increment)
    end
  end

  it 'knows how to #insert_object' do
    point = Map::Point.new(1, 2)
    object_class = Object.new
    new_fake_object = mock 'new fake object'
    object_class.should_receive(:new).with(subject.map).and_return(new_fake_object)
    fake_cell = mock 'cell'
    subject.map.should_receive(:cell_at).with(point).and_return(fake_cell)
    fake_cell.should_receive(:<<).with(new_fake_object)
    subject.instance_variable_set('@cash', BigDecimal('1'))
    subject.should_receive(:cost_for_class).with(object_class).and_return(BigDecimal('0.2'))
    subject.insert_object(point, object_class)
    subject.cash.should == BigDecimal('0.8')
  end

  it 'has costs for all of the Simcity object types' do
    cost_mappings = {
      House => '50',
      Structure::Road  => '10',
      PowerPlant => '100',
      WaterPump => '100',
      GarbageDump => '100'
    }
    cost_mappings.each_pair do |klass, price|
      subject.cost_for_class(klass).should == BigDecimal(price)
    end
  end
end

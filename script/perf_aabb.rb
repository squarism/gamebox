require 'benchmark'
require '../lib/gamebox'

class BoxedActor
  include Kvo
  kvo_attr_accessor :x, :y
  attr_accessor :w, :h

  can_fire_anything

  def initialize(x,y,w,h)
    @kvo_x = x
    @kvo_y = y
    @w = w
    @h = h
  end

  def bb
    @bb ||= Rect.new(x,y,w,h)
  end

end
# require 'perftools'
# PerfTools::CpuProfiler.start("/tmp/perf.txt")


NUM = 1_000
Benchmark.bm(60) do |b|
  b.report("full") do
    tree = SpatialTree.new :thing

    thing = BoxedActor.new 1, 2, 3, 4
    tree.add thing
    things = []
    100.times do |i|
      t = BoxedActor.new i, i, i, i
      things << t
      tree.add t
    end

    NUM.times do 
      it = BoxedActor.new 1, 2, 3, 4
      tree.add it

      thing.x + 1
      things[20..40].each do |t|
        t.x += rand(40)-20
      end

      tree.query thing.bb do
      end

      tree.remove it
    end
  end
end

# PerfTools::CpuProfiler.stop
# be pprof.rb --text /tmp/perf.txt



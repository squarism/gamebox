require 'physical_level'
require 'walls'

class PlaygroundLevel < PhysicalLevel
  def setup
    i = @input_manager
    @shooter = create_actor :box_shooter, :x => 30, :y => 700

    create_actor(:left_wall)
    create_actor(:right_wall)
    create_actor(:top_wall)
    create_actor(:bottom_wall)

    space.gravity = vec2(0, 300)

    i.reg KeyPressed, :space do
      create_actor :clicky, :x => @mouse_x, :y => @mouse_y
    end

    i.reg MouseMotionEvent do |evt|
      @mouse_x = evt.pos[0]
      @mouse_y = evt.pos[1]
    end

#    space.add_collision_func(:clicky, [:clicky]) do |box,wall|
##                             , :left_wall, :right_wall, :top_wall, :bottom_wall]) do |box, wall|
#      puts "Box #{box.inspect} ran into wall #{wall.inspect}"
#      clicky = director.find_physical_obj box
#      p clicky.body.p
#      p clicky.body.v
#    end

    space.elastic_iterations = 3
  end

  def draw(target, x_off, y_off)
    target.fill [25,25,25,255]
  end
end


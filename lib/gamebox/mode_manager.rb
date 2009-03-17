require 'inflector'
class ModeManager

  constructor :resource_manager, :actor_factory
  def setup
    @modes = {}
    @actor_factory.mode_manager = self
    modes = @resource_manager.load_config('mode_level_config')[:modes]
    for mode, levels in modes
      mode_klass_name = Inflector.camelize mode.to_s+"Mode"
      begin
        require mode.to_s+"_mode"
      rescue LoadError
        # hope it's defined somewhere else
      end
      mode_klass = ObjectSpace.const_get mode_klass_name
      add_mode mode, mode_klass.new(@actor_factory, levels)
    end
  end

  def add_mode(mode_sym, mode_instance)
    @modes[mode_sym] = mode_instance
    @mode = mode_sym unless @mode
    mode_instance
  end

  def change_mode_to(mode, *args)
    @modes[@mode].stop unless @modes[@mode].nil?
    @mode = mode
    @modes[@mode].start *args
  end

  def current_mode
    @modes[@mode]
  end

  def update(time)
    @modes[@mode].update time unless @modes[@mode].nil?
  end

  def draw(target)
    @modes[@mode].draw target unless @modes[@mode].nil?
  end
end
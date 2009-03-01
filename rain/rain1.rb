# Rain1 by Thomas R. "TomK32" Koll
#
# draws raindrops as bezier shapes and moves them downwards
# 
# available key commands:
#  + make raindrops heavier/bigger
#  - make raindrops smaller
#  a more raindrops
#  s less raindrops
#  <SPACE>
#
# License: Same as processing
#
require 'ruby-processing'

class Rain1 < Processing::App

  def setup
    frame_rate 30
    @rain_drops = []
    @rain_drops.extend Runnable
    @rain_drops_size = 20
    @rain_drops_weight = 20
    @paused = false
    $app.textFont($app.loadFont("Univers66.vlw"), 15)
  end

  def draw
    return if @paused
    # we fill up with new drops randomly
    fill_up while rand(@rain_drops_size/3) < (@rain_drops_size - @rain_drops.size)
    
    drop_rate = @rain_drops.size/@rain_drops_size.to_f
    # the less drops the darker it is
    background (127+127*(@rain_drops.size/@rain_drops_size.to_f))

    @rain_drops.run
    $app.text("%i of %i drops with a size of %i" % [@rain_drops.size, @rain_drops_size, @rain_drops_weight], 10, 20)
  end

  def fill_up
    @rain_drops << RainDrop.new(rand(width), rand(height/2) - height/2, @rain_drops_weight) if @rain_drops.size < @rain_drops_size
  end

  def keyTyped(key)
    case key.keyChar.chr
      when "+": @rain_drops_weight += 5
      when "-": @rain_drops_weight -= 5 if @rain_drops_weight > 10
      when "a": @rain_drops_size += 5
      when "s": @rain_drops_size -= 5 if @rain_drops_size > 5
      when " ": @paused = !@paused
    end
  end

  module Runnable
    def run
      self.reject! { |item| item.dead? }
      self.each { |item| item.run }
    end
  end

  class RainDrop
    def initialize(x, y, weight = nil)
      @weight = weight || 10
      @original_height = y
      @x, @y = x, y
      render(x,y,weight)
    end
    def render(x,y,weight)
      $app.fill(100, 100, 200)
      $app.noStroke
      $app.bezier(x, y,  x-(weight/2), y+weight,  x+(weight/2), y+weight,  x, y)
    end
    def dead?
      @y > $app.height
    end
    def run
      @y = @y + @weight
      @x = @x - rand(6)
      render(@x,@y,@weight)
    end
  end
end

Rain1.new(:width => 640, :height => 480, :title => "it's raining")

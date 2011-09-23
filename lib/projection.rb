require 'forwardable'
class Projection
  extend Forwardable
  include Enumerable
  
  def_delegators :@projection, :count, :inject, :each, :to_a
    
    
  def initialize(pixel_arrays)
    @projection = []
    pixel_arrays.each do |px_array|
      @projection << 0
      px_array.each do |pixel|
        pixel_is_dark = (pixel.red + pixel.green + pixel.blue) < 3 * 2**15
        @projection[-1] += 1 if pixel_is_dark
      end
    end
  end
  
  def local_maxima(threshold)
    slope = []
    result = []
    padded_projection = [0] + @projection + [0]
    @projection.each_index do |i|
      slope << (padded_projection[i+1] - padded_projection[i-1]) / 2
    end
    
    slope.each_index do |i|
      j = i+1
      j += 1 while slope[j] == 0 && j < slope.size-1
      
      if(slope[i] > 0 && slope[j] <= 0 && (@projection[i] > threshold || @projection[i+1] > threshold))
        result[result.length] = i
      end
      
      break if i == slope.length - 2
    end
     return result
  end

end
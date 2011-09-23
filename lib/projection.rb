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
    result = []
    
    0.upto(slope.length - 2) do |i|
      j = i+1
      j += 1 while slope[j] == 0 && j < slope.size-1
      
      slope_changes = slope[i] > 0 && slope[j] <= 0
      projection_meets_threshold = @projection[i] > threshold || @projection[i+1] > threshold
      
      result[result.length] = i if slope_changes && projection_meets_threshold
    end
    
    return result
  end

  private 
  def slope
    result = []
    padded_projection = [0] + @projection + [0]
    
    @projection.each_index {|i| result << (padded_projection[i+1] - padded_projection[i-1]) / 2 }
    
    return result
  end
  
end
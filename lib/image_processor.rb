require 'RMagick'

class ImageProcessor
  include Magick
  attr_accessor :image
  
  def initialize(path_to_image)
    @image = ImageList.new(path_to_image)
  end
  
  def display
    @image.display
  end
  
  def rows
    result = []
    (0..(@image.rows-1)).each do |row_num|
      result << @image.get_pixels(0, row_num, @image.columns, 1)
    end
    return result
  end
  
  def columns
    result = []
    (0..(@image.columns-1)).each do |col_num|
      result << @image.get_pixels(col_num, 0, 1, @image.rows)
    end
    return result
  end 
  
  def projection(pixel_arrays)
    counts = []
    pixel_arrays.each do |px_array|
      counts << 0
      px_array.each do |pixel|
        pixel_is_dark = (pixel.red + pixel.green + pixel.blue) < 3 * 2**15 
        counts[-1] += 1 if pixel_is_dark
      end
    end
    return counts
  end
  
  def y_projection
    projection(rows)
  end
  
  def x_projection
    projection(columns)
  end
  
end




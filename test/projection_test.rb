require 'test_helper'
require_relative '../lib/image_processor'
require_relative '../lib/projection'

class ProjectionTest < Test::Unit::TestCase
  def setup 
    @ip = ImageProcessor.new('test/slope_change_test.gif')
  end
  
  def test_projection_gives_correct_local_maxima
    assert_equal [1, 6, 12, 15], @ip.y_projection.local_maxima(threshold = 0)
  end
  
  def test_y_projection_gives_accurate_count_of_dark_pixels_per_row
    assert @ip.y_projection.count == @ip.image.rows, "The y projection was not equal to the number of rows"
    assert_equal [1, 3, 1, 1, 2, 5, 4, 2, 1, 4, 2, 6, 6, 0, 7, 2, 0, 0, 1, 3], @ip.y_projection.to_a
  end
  
  def test_x_projection_gives_accurate_count_of_dark_pixels_per_column
    assert @ip.x_projection.count == @ip.image.columns, "The x projection was not equal to the number of columns"
    assert_equal [17, 12, 8, 6, 4, 3, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], @ip.x_projection.to_a
  end
end
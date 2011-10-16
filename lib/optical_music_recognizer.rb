class OpticalMusicRecognizer
  LINES_PER_STAFF = 5
  
  def initialize(sheet_music_image, image_processor=ImageProcessor)
    @image_processor = image_processor.new(sheet_music_image)
  end
  
  def staves
    local_maxima = @image_processor.y_projection.local_maxima(threshold_for_stave_detection)
    return stave_ranges(local_maxima)
  end
  
  
  private
  def threshold_for_stave_detection
    @image_processor.y_projection.inject(:+) / @image_processor.y_projection.count
  end
  
  def tightest_cluster(windows)
    distances = windows.map{|x| x[-1] - x[0]}
    return windows[distances.index(distances.min)]
  end
  
  
  def stave_ranges(line_ranges)
    windows = [] 
    line_ranges.each_cons(5){|x| windows << x}
    
    stave_indexes = []
    while windows.count > 0 
      stave_indexes << tightest_cluster(windows)
      windows.keep_if{|window| (window & stave_indexes[-1]).empty? }
    end
    
    as_ranges = stave_indexes.map{|x| x.first..x.last}.sort{|x,y| x.first <=> y.first}
    
    return expand_to_include_off_staff_notes(as_ranges)
  end
  
  def expand_to_include_off_staff_notes(staff_ranges)
    return staff_ranges.map do |range|
      lower_index = staff_ranges.index(range) > 0 ? staff_ranges.fetch(staff_ranges.index(range)-1).first : 0
      upper_index = staff_ranges.fetch(staff_ranges.index(range)+1, range.last..@image_processor.rows.count-1).last
      new_first = @image_processor.y_projection.to_a[lower_index..range.first].rindex{|x| x < threshold_for_stave_detection / 4}.to_i + lower_index
      new_last = @image_processor.y_projection.to_a[range.last..upper_index].index{|x| x < threshold_for_stave_detection / 4} + range.last
      new_first..new_last
    end
  end

end
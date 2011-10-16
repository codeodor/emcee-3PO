class OpticalMusicRecognizer
  LINES_PER_STAFF = 5
  
  def initialize(sheet_music_image, image_processor=ImageProcessor)
    @image_processor = image_processor.new(sheet_music_image)
  end
  
  def staves
    threshold = @image_processor.y_projection.inject(:+) / @image_processor.y_projection.count
    local_maxima = @image_processor.y_projection.local_maxima(threshold)
    return stave_ranges(local_maxima)
  end
  
  
  private
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
    return staff_ranges
  end

end
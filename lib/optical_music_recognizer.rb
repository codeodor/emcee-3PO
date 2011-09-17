class OpticalMusicRecognizer
  LINES_PER_STAFF = 5
  
  def initialize(sheet_music_image)
    @image_processor = ImageProcessor.new(sheet_music_image)
  end
  
  def systems
    threshold = @image_processor.y_projection.inject(:+) / @image_processor.y_projection.count * 4 / 5 
    result = []
    is_within_system = false
    start_of_system, end_of_system = -1, -1
    @image_processor.y_projection.each_with_index do |row_magnitude, i|
      if row_magnitude > threshold && !is_within_system
        is_within_system = true
        start_of_system = i
      end
      if row_magnitude < threshold && is_within_system
        is_within_system = false
        end_of_system = i
        result << (start_of_system..end_of_system)
      end
    end
    
    chunks = Array.new(result.size / LINES_PER_STAFF, [])
    0.upto(chunks.size-1) do |i|
      chunks[i] = result.slice(i * LINES_PER_STAFF, LINES_PER_STAFF)
    end
    
    return chunks
  end
  
end
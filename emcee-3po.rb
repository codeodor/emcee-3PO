require './markov_model'
require '../arx/lib/archaeopteryx'

file = File.expand_path "example_music.txt"
mm = MarkovModel.new
mm.create_model(file, 2, /\s/)
notes = mm.generate(100)

output_music_filename = "example_music.rb"

music = {}
notes.each_with_index do |note, index|
  unless note == ",,"
    music["MIDIator::Notes::" << note] ||= [0] * notes.length
    music["MIDIator::Notes::" << note][index] = 1
  end
end

puts notes.inspect

code=<<END
  def music  
    #{music.inspect.gsub(/"/,"")}
  end


  def note(midi_note_number)
    Note.create(:channel => 2,
                :number => midi_note_number,
                :duration => 0.5,
                :velocity => 100 + rand(27))
  end

  static = L{1.0}
  dynamic = L{rand}
  check_every_drum = L{|queue| queue[queue.size - 1]}
  check_random_drums = L{|queue| queue[rand(queue.size)]}

  notes = []
  
  music.each do |midi_note_number, probabilities|
    notes << Drum.new(:note => note(midi_note_number),
                      :when => L{|beat| false},
                      :number_generator => static,
                      :next => check_every_drum,
                      :probabilities => probabilities )
  end
  
  notes
END

File.open(output_music_filename, "w") do |file|
  file.puts code
end



$clock = Clock.new(60)
$mutation = L{|measure| false}
$measures = 4

@loop = Arkx.new(:clock => $clock, # rename Arkx to Loop
                 :measures => $measures,
                 :logging => false,
                 :evil_timer_offset_wtf => 0.2,
                 :generator => Rhythm.new(:drumfile => output_music_filename,
                                          :mutation => $mutation))
@loop.go



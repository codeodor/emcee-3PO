class MarkovModel
  # I realize this is all rather hacky.
  def create_model(file, order, split_on)
    entire_file = IO.read(file)
    @order = order
    
    @entire_file_split = entire_file.split(split_on)

    #construct a hash like:
    #first 'order' letters, letter following, increment count
    @model = {}

    @entire_file_split.each_with_index do |c, i|
      this_group = @entire_file_split[i, order]
      next_letter = @entire_file_split[i+order, 1]
      
      next if next_letter == []

	    @model[this_group] ||= { next_letter => 1 }
	    @model[this_group][next_letter] ||= 0
      @model[this_group][next_letter] += 1
    end
  end

  def generate(amount)
    start_group = @entire_file_split[0,@order]
    result = start_group
    
    this_group = start_group
    (0..(amount-@order)).each do |i|
      next_tokens_to_choose_from = @model[this_group]
      #puts @model.inspect
      #puts this_group.inspect
      #puts @model[this_group].inspect
      #puts "****" * 20
      #construct probability hash
      num = 0
      probabilities = {}
      next_tokens_to_choose_from.each do |key, value|
        num += value
        probabilities[key] = num
      end

      #select next letter
      index = rand(num)
      matches = probabilities.select {|key, value| index <= value }
      sorted_by_value = matches.sort{|a,b| a[1]<=>b[1]}
      next_token = sorted_by_value[0][0]
      
      result << next_token

      #shift the group
      this_group = this_group[1,@order-1] + next_token
    end
    return result.flatten
  end

  def print_model
    require 'pp'
    PP.pp(@model)
  end
end
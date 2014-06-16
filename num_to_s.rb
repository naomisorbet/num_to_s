def num_to_s(num, base)
  # a "to_s" method which converts numbers up to base 16
	num_string_dict = 
          { 0 => "0",
            1 => "1",
						2 => "2",
            3 => "3",
            4 => "4",
            5 => "5",
            6 => "6",
            7 => "7",
            8 => "8",
            9 => "9",
            10 => "A",
            11 => "B",
            12 => "C",
            13 => "D",
            14 => "E",
            15 => "F" }
            
	answer = ""
  diminishing_num = num
  
  while diminishing_num > 0 
    # get trailing digit of d_n, convert to s, prepend to answer
    subnum = diminishing_num % base
    substring = num_string_dict[subnum]
    answer = substring + answer
    
    # eliminate final digit from d_n
    
    diminishing_num /= base
  end
  answer  
end



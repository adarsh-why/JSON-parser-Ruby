def null_parser input
    p "pinged null"
    if input[0..3] == 'null'
        return nil, input[4..-1].strip, true
    else
        return "null fail"
    end
end

def colon_parser input
    p "pinged colon"
    if input[0] == ':'
        return ':', input[1..-1].lstrip, true
    else
        return "colon fail"
    end
end

def bool_parser input
    p "pinged bool"
    if input[0..3] == 'true'
        return true, input[4..-1].strip, true
    elsif input[0..4] == 'false'
        return false, input[5..-1].strip, true
    else
        return "bool fail"
    end
end

def string_parser input
    
    if input[0] == '"'
        input = input[1..-1]
        indx = input.gsub('\"', '"').index('"')
        return input[0..(indx-1)].strip, input[(indx+1)..-1].strip, true
    else
        return "string fail"
    end
end

def num_parser input
    p "pinged num"
        indx = (input.index(',') or input.index(']'))
        num = input[0...indx]
        if num[/\.\d+/]
            return num.to_f, input[indx..-1], true
        elsif num[/\d+/]
            return num.to_i, input[indx..-1], true
        else
            "num fail"
        end
end

def comma_parser input
    p "pinged comma"
    p "input in comma is #{input}"
    if input[0] == ','
        return ',', input[1..-1].strip, true
    else
        return "comma fail"
    end
end

def array_parser input
    p "pinged array_parser"
    if input[0] == '['
        list = []
        input = input[1..-1]
        while input != nil and input.length > 0
            if input[0] == '['
                indx = input.index(']')
                list << element_parser(input[0..indx])
                input = input[(indx+1)..-1]
            end
            arr,rem = element_parser input
            list << arr unless arr == nil #and so null parser give empty output
            p "arr is #{list}"
            p "rem is #{input}"
            input = rem
        end
        list.delete(",")
        return list, true 
    end
end

def element_parser input
    p "pinged element"
    flag = false

    arr,rem,flag = bool_parser input
    return arr, rem if flag == true

    arr,rem,flag = num_parser input
    return arr, rem if flag == true
    
    arr,rem,flag = null_parser input
    return arr, rem if flag == true
    
    arr,rem,flag = comma_parser input
    return arr, rem if flag == true
    
    arr,rem,flag = colon_parser input
    return arr, rem if flag == true
    
    arr,rem,flag = string_parser input
    return arr, rem if flag == true
end 

def object_parser input
end

def parse_house input
end

while true
print "JSON>> "
input = gets.chomp
p array_parser(input)
end

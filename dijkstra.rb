#!/usr/bin/env ruby


def combine(a, b, map)
  if (a < 0) ^ (b < 0)
    -map[a.abs][b.abs]
  else
    map[a.abs][b.abs]
  end
end

def display(x, map)
  if x < 0
    "-" + map[x.abs]
  else
    map[x]
  end
end

def solve(s, x)
  map = [
    [0, 1, 2, 3, 4],
    [1, 1, 2, 3, 4],
    [2, 2,-1, 4,-3],
    [3, 3,-4,-1, 2],
    [4, 4, 3,-2,-1]
  ]

  convert = {
    "1" => 1,
    "i" => 2,
    "j" => 3,
    "k" => 4
  }

  invert = convert.invert

  fb = [] # front buffer
  bb = [] # back buffer

  # puts "====solve===="

  # reduce size of x
  if true
    trim_size = 4
    buf = (s * trim_size).split('')
    temp = 0
    until buf.empty?
      temp = combine(temp, convert[buf.shift], map)
      # puts "#{display(temp,invert)}  #{buf.join(",")}"
    end
    # puts "trim? #{temp}"
    if temp == 1
      trim = (x - 6) / trim_size
      org = x
      x -= trim * trim_size if trim > 0
      # puts "trim x from #{org} to #{x}"
    end
  end

  # finding i at the front
  temp = 0
  until fb.empty? && x == 0 do
    x -= 1 and fb = s.split('') if fb.empty?
    temp = combine(temp, convert[fb.shift], map)
    # puts "  temp:#{temp}, fb:#{fb.join(',')}, x:#{x}"
    break if temp == 2
  end

  return "NO" unless temp == 2

  # finding k at the back
  temp = 0
  until fb.empty? && bb.empty? && x == 0 do
    if bb.empty?
      if x > 0
        x -= 1
        bb = s.split('')
      else
        bb = fb
        fb = []
      end
    end

    temp = combine(convert[bb.pop], temp, map)
    # puts "  temp:#{temp}, bb:#{bb.join(',')}, x:#{x}, fb:#{fb.join(',')}"
    break if temp == 4
  end

  return "NO" unless temp == 4

  # merge reminding to see if it is j
  temp = 0
  until fb.empty? && bb.empty? && x == 0 do
    if !fb.empty?
      _next = fb.shift
    elsif x > 0
      x -= 1
      fb = s.split('')
      _next = fb.shift
    else
      _next = bb.shift
    end
    temp = combine(temp, convert[_next], map)
  end

  return "NO" unless temp == 3

  return "YES"
end

case_count = gets.chomp.to_i
case_count.times { |cc|
  buffer = gets.chomp.split(' ')
  l = buffer[0].to_i
  x = buffer[1].to_i
  s = gets.chomp

  # puts "  s:#{s}, x:#{x}"
  ans = s.split('').uniq.length == 1 ? "NO" : solve(s, x)

  puts "Case ##{cc+1}: #{ans}"
}

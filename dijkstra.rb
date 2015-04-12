#!/usr/bin/env ruby


class Ch
  attr_accessor :value, :sign

  def initialize(value, sign=1)
    @value = value
    @sign = sign

    @map = {
      "11" => "1",
      "1i" => "i",
      "1j" => "j",
      "1k" => "k",

      "i1" => "i",
      "ii" => "-1",
      "ij" => "k",
      "ik" => "-j",

      "j1" => "j",
      "ji" => "-k",
      "jj" => "-1",
      "jk" => "i",

      "k1" => "k",
      "ki" => "j",
      "kj" => "-i",
      "kk" => "-1",

      "i" => "i",
      "j" => "j",
      "k" => "k"
    }
  end

  def +(that)
    if that.is_a? Ch
      value = @map[self.value + that.value]
      sign = self.sign * that.sign
    else
      value = @map[self.value + that]
      sign = self.sign
    end

    if value[0] == "-"
      value = value[1]
      sign = sign * -1
    end

    Ch.new(value, sign)
  end

  def to_s
    "#{sign == 1 ? '' : '-'}#{value}"
  end

  def ==(that)
    self.value == that.value && self.sign == that.sign
  end

  def eq(s)
    @value == s && @sign == 1
  end
end

def solve(s, x)
  fb = [] # front buffer
  bb = [] # back buffer

  # puts "====solve===="

  # reduce size of x
  if true
    trim_size = 4
    buf = (s * trim_size).split('')
    temp = Ch.new('')
    until buf.empty?
      temp = temp + buf.shift
      # puts "#{temp}  #{buf.join(",")}"
    end
    # puts "trim? #{temp}"
    if temp.eq("1")
      trim = (x - 6) / trim_size
      org = x
      x -= trim * trim_size if trim > 0
      # puts "trim x from #{org} to #{x}"
    end
  end

  # finding i at the front
  temp = Ch.new('')
  until fb.empty? && x == 0 do
    x -= 1 and fb = s.split('') if fb.empty?
    temp = temp + fb.shift
    # puts "  temp:#{temp}, fb:#{fb.join(',')}, x:#{x}"
    break if temp.eq("i")
  end

  return "NO" unless temp.eq("i")

  # finding k at the back
  temp = Ch.new('')
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

    temp = Ch.new(bb.pop) + temp
    # puts "  temp:#{temp}, bb:#{bb.join(',')}, x:#{x}, fb:#{fb.join(',')}"
    break if temp.eq("k")
  end

  return "NO" unless temp.eq("k")

  # merge reminding to see if it is j
  temp = Ch.new('')
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
    temp = temp + _next
  end

  return "NO" unless temp.eq("j")

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

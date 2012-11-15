module StringUtil
  def longest_common_substring(s1, s2)
    m = Array.new(s2.length){ [0] * s1.length }
    longest, x_longest = 0,0
    (1 .. 1 + s1.length).each do |x|
      (1 .. 1 + s2.length).each do |y|
        if s1[x-1] == s2[y-1]
          m[x][y] = m[x-1][y-1] + 1
          if m[x][y] > longest
            longest = m[x][y]
            x_longest = x
          else
            m[x][y] = 0
          end
        end
      end
    end
    s1[x_longest - longest .. x_longest]
  end
end
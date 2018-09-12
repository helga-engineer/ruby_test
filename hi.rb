require 'csv'
require 'phonetic'
require 'text'
require 'byebug'
require 'fuzzystringmatch'
# main = CSV.read('advanced.csv')
main = CSV.read('normal.csv')

def r_h(h, r) #row with heading
  with_soundex = r.map{|e|  e.soundex if e}
  {compare: Hash[h.zip(with_soundex)], back_up: r}
end
hh = main.shift #  remove heading row
dupl = []
for ii in 0..(main.length - 1)
  single_match_count = 0
  for j in 0..(main.length - 1)
    unless ii == j  # skip checking with self row
      ff = r_h(hh, main[ii])
      ss = r_h(hh, main[j])
      count = 0
      ff[:compare].merge(ss[:compare]) do | k, v1, v2 |
        count += 1 if (v1 == nil) && v2
        count += 1 if (ff[:compare] >= {k => ss[:compare][k]})
      end
      if count > 7
        ff[:compare]['DUPLICATE'] = []
        ff[:compare]['DUPLICATE'] << main[j][0]
        break
      end
    end
  end
  if ff[:compare] && ff[:compare]['DUPLICATE']
    dupl.push [ff[:compare]['DUPLICATE'][0].to_i, ss[:back_up]]
  end
end
p dupl.map { |e|  p e }.count

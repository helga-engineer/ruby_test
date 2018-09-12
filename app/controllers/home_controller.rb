class HomeController < ApplicationController
  def index

  end

  def read_csv
    myfile = params[:file]
    if myfile && myfile.tempfile
      main = CSV.read(myfile.tempfile)
      hh = main.shift #  remove heading row
      dupl = []
      uniq_rows = []
      for ii in 0..(main.length - 1)
        single_match_count = 0
        for j in 0..(main.length - 1)
          unless ii == j  # skip checking with self row
            ff = r_h(hh, main[ii]) # outer loop current row
            ss = r_h(hh, main[j])  # inner loop current row
            count = 0
            ff[:compare].merge(ss[:compare]) do | k, v1, v2 |
              count += 1 if (v1 == nil) && v2
              count += 1 if (ff[:compare] >= {k => ss[:compare][k]})
            end
            if count > 7
              ff[:compare]['DUPLICATE'] = []
              ff[:compare]['DUPLICATE'] << main[j][0]
              break
            else
              ff[:compare]['non_duplicate_rows'] = main[ii][0]  # catching uniq rows to display
            end
          end
        end
        if ff[:compare] && ff[:compare]['DUPLICATE']
          dupl.push [ff[:compare]['DUPLICATE'][0].to_i, ss[:back_up]]
        elsif ff[:compare] && ff[:compare]['non_duplicate_rows']
          uniq_rows.push [ff[:compare]['non_duplicate_rows'].to_i, main[ii]]
        end
      end
      @dupl = dupl.sort_by{|row| row[0] }
      @uniq_rows = uniq_rows
    else
      redirect_to root_path
    end
  end

  def r_h(h, r) #row with heading
    with_soundex = r.map{|e|  e.soundex if e}
    # soundex method is taken from phonetic gem
    # soundex method is utilized here to ignore the minor spelling changes in words
    {compare: Hash[h.zip(with_soundex)], back_up: r}
  end
end

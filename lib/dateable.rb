require 'date'

module Dateable

  def date_conversion
    Date.today.strftime("%m%d%y")
  end

  def square_date(date)
    (date.to_i ** 2).to_s
  end
end

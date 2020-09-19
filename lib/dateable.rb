module Dateable

  def date_conversion
    Date.today.strftime("%m%d%y")
  end

  def square_date
    date_conversion.to_i ** 2
  end
end

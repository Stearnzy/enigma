module Mappable

  def index_mapping(input)
    input.map do |index|
      if index.is_a?(String)
        index
      elsif index > 27 || index < -27
        @alphabet[index % 27]
      else
        @alphabet[index]
      end
    end.join
  end
end
module LetsDoThis
  class Errors < Hash
    def add(key, value)
      self[key] ||= []
      self[key] << value
      self[key].uniq!
    end

    def add_some(errors_hash)
      errors_hash.each do |key, values|
        values.each { |value| add key, value }
      end
    end
  end
end

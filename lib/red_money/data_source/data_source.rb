module RedMoney
  class UnkownDataSource < StandardError
  end

  module DataSource
    Sources = {}

    def self.update symbol, days, to_date
      source = @default if symbol[:source] == :default 
      raise UnkownDataSource, source unless Sources.has_key? source 

      symbol[:data] = Sources[source].update symbol, days, to_date
    end
    
    def self.register name, source
      name = name.to_sym
      Sources[name] = source
    end 

    def self.set_default name
      raise UnkownDataSource, name unless Sources.has_key? name
      @default = name
    end
  end
  
end

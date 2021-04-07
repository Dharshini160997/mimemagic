require 'csv'
class CsvDb
  class << self
    def convert_save(target_model, csv_data, &block)
      CSV.parse(csv_data, :headers => true, header_converters: :symbol ) do |row|
        data = row.to_hash
        if data.present?
          if (block_given?)
             block.call(target_model, data)
           else
             target_model.create!(data)
           end
         end
      end
    end
  end
end
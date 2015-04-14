# http://stackoverflow.com/questions/9423279/papertrail-and-carrierwave#answer-29491427
module PaperTrail
  module Model
    module InstanceMethods
      private

      # override to keep only basename for carrierwave attributes in object hash
      def item_before_change
        previous = self.dup
        # `dup` clears timestamps so we add them back.
        all_timestamp_attributes.each do |column|
          if self.class.column_names.include?(column.to_s) and not send("#{column}_was").nil?
            previous[column] = send("#{column}_was")
          end
        end
        enums = previous.respond_to?(:defined_enums) ? previous.defined_enums : {}
        previous.tap do |prev|
          prev.id = id # `dup` clears the `id` so we add that back
          changed_attributes.select { |k,v| self.class.column_names.include?(k) }.each do |attr, before|
            if defined?(CarrierWave::Uploader::Base) && before.is_a?(CarrierWave::Uploader::Base)
              prev.send(:write_attribute, attr, before.url && File.basename(before.url))
            else
              before = enums[attr][before] if enums[attr]
              prev[attr] = before
            end
          end
        end
      end

      # override to keep only basename for carrierwave attributes in object_changes hash
      def changes_for_paper_trail
        _changes = changes.delete_if { |k,v| !notably_changed.include?(k) }
        if PaperTrail.serialized_attributes?
          self.class.serialize_attribute_changes(_changes)
        end
        if defined?(CarrierWave::Uploader::Base)
          Hash[
              _changes.to_hash.map do |k, values|
                [k, values.map { |value| value.is_a?(CarrierWave::Uploader::Base) ? value.url && File.basename(value.url) : value }]
              end
          ]
        else
          _changes.to_hash
        end
      end

    end
  end
end
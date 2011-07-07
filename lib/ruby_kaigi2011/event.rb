require File.join(File.dirname(__FILE__), "yaml_loader")
require File.join(File.dirname(__FILE__), "localizer")

module RubyKaigi2011
  class Event < OpenStruct
    extend YamlLoader
    include Localizer

    base_dir Rails.root.join("db/2011/events/")

    def sub_events
      @sub_events ||= Event.find_by_ids(sub_event_ids || [])
    end

    def ==(other)
      return false unless other.is_a?(Event)
      self._id == other._id
    end

    def same_or_contain?(other)
      self == other || !!self.sub_events.detect {|sub| sub == other }
    end

    def to_hash
      hash = @table.dup
      hash.delete(:sub_event_ids)
      hash[:sub_events] = sub_events.map(&:to_hash) unless sub_events.empty?
      hash
    end
  end
end

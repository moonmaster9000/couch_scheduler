module CouchScheduler
  module CouchVisibleIntegration
    def self.included(base)
      base.extend ClassMethods
      base.view_by :couch_schedule_and_shown, :map => Map.new(base, :shown).to_s, :reduce => '_count'
      base.view_by :couch_schedule_and_hidden, :map => Map.new(base, :hidden).to_s, :reduce => '_count'
    end

    module ClassMethods
      def by_schedule(options={})
        shown = options.delete :shown
        hidden = options.delete :hidden

        if shown == true || hidden == false
          by_couch_schedule_and_shown CouchScheduler::Options.new(options).to_hash
        elsif hidden == true || shown == false
          by_couch_schedule_and_hidden CouchScheduler::Options.new(options).to_hash
        else
          super
        end
      end
    end
  end
end

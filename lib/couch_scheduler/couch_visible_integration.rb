module CouchScheduler
  module CouchVisibleIntegration
    def self.included(base)
      base.extend ClassMethods
      base.view_by :couch_schedule_and_shown, :map => Map.new(base, :shown).to_s, :reduce => '_count'
      base.view_by :couch_schedule_and_hidden, :map => Map.new(base, :hidden).to_s, :reduce => '_count'
    end

    module ClassMethods
      def by_schedule_and_shown(options={})
        by_couch_schedule_and_shown CouchScheduler::TimeMassager.massage(options)
      end

      def by_schedule_and_hidden(options={})
        by_couch_schedule_and_hidden CouchScheduler::TimeMassager.massage(options)
      end

      def count_schedule_and_shown(options={})
        count_by_map :by_schedule_and_shown, options
      end

      def count_schedule_and_hidden(options={})
        count_by_map :by_schedule_and_hidden, options
      end
    end
  end
end

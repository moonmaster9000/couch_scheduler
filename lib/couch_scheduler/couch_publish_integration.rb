module CouchScheduler
  module CouchPublishIntegration
    def self.included(base)
      base.extend ClassMethods
      base.view_by :couch_schedule_and_unpublished, :map => Map.new(base, :unpublished).to_s, :reduce => '_count'
      base.view_by :couch_schedule_and_published, :map => Map.new(base, :published).to_s, :reduce => '_count'
    end

    module ClassMethods
      def by_schedule_and_published(options={})
        by_couch_schedule_and_published CouchScheduler::TimeMassager.massage(options)
      end

      def by_schedule_and_unpublished(options={})
        by_couch_schedule_and_unpublished CouchScheduler::TimeMassager.massage(options)
      end

      def count_schedule_and_published(options={})
        count_by_map :by_schedule_and_published, options
      end

      def count_schedule_and_unpublished(options={})
        count_by_map :by_schedule_and_unpublished, options
      end
    end
  end
end

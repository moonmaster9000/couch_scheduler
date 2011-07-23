module CouchScheduler
  module CouchPublishIntegration
    def self.included(base)
      base.extend ClassMethods
      base.view_by :couch_schedule_and_unpublished, :map => Map.new(base, :unpublished).to_s, :reduce => '_count'
      base.view_by :couch_schedule_and_published,   :map => Map.new(base, :published).to_s,   :reduce => '_count'
    end

    module ClassMethods
      def by_schedule(options={})
        published   = options[:published]
        unpublished = options[:unpublished]

        if published == true || unpublished == false
          by_couch_schedule_and_published CouchScheduler::Options.new(options).to_hash
        elsif unpublished == true || published == false
          by_couch_schedule_and_unpublished CouchScheduler::Options.new(options).to_hash
        else
          super
        end
      end
    end
  end
end

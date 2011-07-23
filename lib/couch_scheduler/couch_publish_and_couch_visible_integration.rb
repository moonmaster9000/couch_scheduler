module CouchScheduler
  module CouchVisibleCouchPublishIntegration
    def self.included(base)
      base.extend ClassMethods
      base.view_by :couch_schedule_and_published_and_shown,  :map => Map.new(base, :published, :shown).to_s,  :reduce => '_count'
      base.view_by :couch_schedule_and_published_and_hidden, :map => Map.new(base, :published, :hidden).to_s, :reduce => '_count'
    end

    module ClassMethods
      def by_schedule(options={})
        shown       = options[:shown]
        hidden      = options[:hidden]
        published   = options[:published]
        unpublished = options[:unpublished]

        if shown == true && published == true
          by_couch_schedule_and_published_and_shown CouchScheduler::Options.new(options).to_hash
        elsif hidden == true && published == true
          by_couch_schedule_and_published_and_hidden CouchScheduler::Options.new(options).to_hash
        else
          super
        end
      end
    end
  end
end

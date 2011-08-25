module CouchScheduler
  module CouchVisibleIntegration
    def self.included(base)
      base.couch_view :within_couch_schedule do
        map CouchScheduler::Map do
          conditions CouchScheduler::Conditions::Shown, CouchScheduler::Conditions::Hidden
        end
      end
    end
  end
end

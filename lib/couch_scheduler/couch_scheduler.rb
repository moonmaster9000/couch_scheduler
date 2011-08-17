module CouchScheduler
  def self.included(base)
    unless base.ancestors.include?(CouchView)
      base.send :include, CouchView
    end

    base.property :start, Date
    base.property :end, Date
    base.validate :validate_start_and_end
    base.extend ClassMethods

    
    if defined?(CouchPublish) && base.ancestors.include?(CouchPublish)
      base.send :include, CouchPublishIntegration
    else
      base.couch_view :within_couch_schedule do
        map CouchScheduler::Map
      end
    end
# 
#     if defined?(CouchVisible) && base.ancestors.include?(CouchVisible)
#       base.send :include, CouchVisibleIntegration
#     end
# 
#     if defined?(CouchVisible) && base.ancestors.include?(CouchVisible) && defined?(CouchPublish) && base.ancestors.include?(CouchPublish)
#       base.send :include, CouchVisibleCouchPublishIntegration
#     end
  end

  module ClassMethods
    def map_within_schedule!
      map_within_schedule.get!
    end

    def count_within_schedule!
      count_within_schedule.get!
    end

    def map_within_schedule
      map_within_couch_schedule.key(Time.now.to_date)
    end

    def count_within_schedule
      count_within_couch_schedule.key(Time.now.to_date)
    end
  end

  def within_schedule?
    start_valid = true
    end_valid   = true

    start_valid = Time.now >= self.start  if self.start
    end_valid   = Time.now < self.end     if self.end

    start_valid && end_valid
  end

  private
  def validate_start_and_end
    if self.end && self.start && self.end < self.start
      errors[:end] = "must be greater than start"
    end
  end
end

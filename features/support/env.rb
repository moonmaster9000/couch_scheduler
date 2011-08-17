$LOAD_PATH.unshift './lib'

require 'couch_scheduler'
require 'couchrest_model_config'
require 'couch_publish'
require 'couch_visible'
require 'timecop'

CouchRest::Model::Config.edit do
  database do
    default "http://admin:password@localhost:5984/couch_scheduler_test"
  end
end

Before do
  CouchRest::Model::Config.default_database.recreate!
  Timecop.return

  Object.class_eval do
    if defined? Article
      remove_const "Article"
    end
  end
end

module Searchable

    extend ActiveSupport::Concern
    included do
        include Elasticsearch::Model
        include Elasticsearch::Model::Callbacks

        settings do
            mappings dynamic: false do
              indexes :content, type: :text
            end
        end
    end
end
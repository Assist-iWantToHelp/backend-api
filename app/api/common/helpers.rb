module Common
  module Helpers
    extend Grape::API::Helpers

    def permitted_params
      @permitted_params ||= rename_keys!(
        declared(params, include_missing: false, include_parent_namespaces: false)
      )
    end

    private

    def rename_keys!(params)
      return params unless route.settings.key?(:aliases)

      params.deep_transform_keys! { |key| route.settings[:aliases][key.to_sym] || key }
    end
  end
end

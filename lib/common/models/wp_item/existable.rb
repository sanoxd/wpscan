# encoding: UTF-8

class WpItem
  module Existable

    def exists?(options = {}, response = nil)
      unless response
        response = Browser.instance.get(url)
      end
      exists_from_response?(response, options)
    end

    protected

    # options:
    #   :error_404_hash
    #   :homepage_hash
    #   :exclude_content REGEXP
    #
    # @return [ Boolean ]
    def exists_from_response?(response, options = {})
      # FIXME : The response is supposed to follow locations, so we should not have 301 or 302.
      # However, due to an issue with Typhoeus or Webmock, the location is not followed in specs
      if [200, 301, 302, 401, 403].include?(response.code)
        if response.has_valid_hash?(options[:error_404_hash], options[:homepage_hash])
          if options[:exclude_content]
            unless response.body.match(options[:exclude_content])
              return true
            end
          else
            return true
          end
        end
      end
      false
    end

  end
end

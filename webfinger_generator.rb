# Webfinger data generator.
#
# Generates a /.well-known/webfinger endpoint that responds with
# the details given in _webfinger.yml (in the root of the project).
#
# Example Webfinger configuration at _webfinger.yml:
#
#   eric@konklone.com:
#     name: Eric Mill
#     website: https://konklone.com
#
# This will create a page at /.well-known/.webfinger that returns:
#
#   {
#     "subject": "eric@konklone.com",
#     "properties": {
#       "http://schema.org/name": "Eric Mill"
#     },
#     "links": [
#       {
#         "rel": "http://webfinger.net/rel/profile-page",
#         "href": "https://konklone.com"
#       }
#     ]
#   }
#
# See the README for more details.
#
# Author: Eric Mill
# Site: https://konklone.com
# Plugin Source: https://github.com/konklone/jekyll-webfinger
# Plugin License: MIT

require 'json' # uses built-in stdlib json

module Jekyll

  class WebfingerGenerator < Generator

    def generate(site)
      @site = site

      config_file = File.join File.dirname(__FILE__), "../_webfinger.yml"
      return unless File.exist?(config_file)
      config = YAML.load_file config_file

      webfinger_dir = File.join @site.dest, ".well-known"
      webfinger_file = File.join webfinger_dir, "webfinger"

      FileUtils.mkdir_p webfinger_dir
      File.open(webfinger_file, "w") do |file|
        file.write jrd_for_config(config)
      end

      @site.static_files << Jekyll::WebfingerFile.new(@site, @site.dest, ".well-known/webfinger", "")
    end

    # generates JRD for the first and only email listed
    def jrd_for_config(config)
      resource = config.keys.first

      acct = resource.start_with?("acct:") ? resource : "acct:#{resource}"

      response = {
        subject: acct,
        properties: {},
        links: []
      }

      config[resource].each do |field, value|
        field = field.to_s # allow symbols
        field_urn = URI.parse(field) rescue nil
        if field_urn and field_urn.scheme and field_urn.scheme.start_with?("http")
          # do nothing, field is already a URN
        else
          # check if we have a best practice mapping for this field
          field = Jekyll::WebfingerGenerator.fields[field] || field
        end

        uri = URI.parse(value) rescue nil
        if uri and uri.scheme and uri.scheme.start_with?("http")
          response[:links] << {rel: field, href: value}
        else
          response[:properties][field] = value
        end
      end

      JSON.generate response
    end

    def self.fields
      @fields ||= YAML.load_file(File.join(File.dirname(__FILE__), "urns.yml"))
    end

  end

  class WebfingerFile < StaticFile
    require 'set'

    def destination(dest)
      File.join(dest, @dir)
    end

    def modified?
      return false
    end

    def write(dest)
      return true
    end
  end
end
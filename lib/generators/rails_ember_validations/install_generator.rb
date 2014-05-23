require 'rails/generators/base'
module RailsEmberValidations
  class InstallGenerator < Rails::Generators::NamedBase





    def add_js
        mode = :coffee
        if File.exists? "app/assets/javascripts/application.js.coffee"
          path = "app/assets/javascripts/application.js.coffee"
        elsif File.exists? "app/assets/javascripts/application.coffee"
          path = "app/assets/javascripts/application.coffee"
        elsif File.exists? "app/assets/javascripts/application.js"
          mode = :js
          path = "app/assets/javascripts/application.js"
        end

        original = File.binread(path)
        if original.include?("require validation-view")
           puts "Skipped validation-view.js inclusion. Allready included"
        else
          if mode == :coffee
            insert_into_file path, :after => %r{#= ['"]?require_self['"]?\s*$} do
              "\n#= require validation-view"
            end
            puts "Added validation-view.js file to #{path}"
          else
            insert_into_file path, :after => %r{//= ['"]?require_self['"]?\s*$} do
              "\n//= require validation-view"
            end
            puts "Added validation-view.js file to #{path}"         
          end
        end
    end



  end
end

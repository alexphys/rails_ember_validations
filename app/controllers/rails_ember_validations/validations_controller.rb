
  class ValidationsController < ApplicationController

    rescue_from CanCan::AccessDenied do |exception|
        render json: {authorization: ["Your are not allowed to #{$action} this #{object_params.first[0]} with this content. Please make changes to your form "]}, status: 403
    end 
    def validate
      validation_object = object
      
      if validation_object.valid?
        render json: :null, status: 200
      else
        
        render json: validation_object.errors, status: 422
      end
    end

    def authorize_new(action)
      authorize_object = object
      authorize! action.to_sym, authorize_object  
    end


    def object
      if object_params.first[1][:id] == nil
        $action = 'create'
        object = Object::const_get(object_params.first[0].capitalize).new(object_params.first[1])
      else
        $action = 'update'
        object = Object::const_get(object_params.first[0].capitalize).find(object_params.first[1][:id])

        object_params.first[1].keys.each do |key|

          if object.attributes.has_key? key
            object[key] = object_params.first[1][key]
          end         
        end      
      end
      cancan =  !!Module.const_get('CanCan') rescue false

      authorize! $action.to_sym, object  if cancan  
      return object        
    end

    private
    def object_params
      params.permit!

      
    end

  end

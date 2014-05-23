# RailsEmberValidations

Rails_ember_validations is a gem for server-side validations in your forms.
Its use is for validations only, it will not process any actions, its up to you to handle the responce.

This gem was created for json responces  with validation and authorization errors.

Although it is designed for functionality with ember.js , you can still use it with
anything you want.


Rails_ember_validations for ember use, works only with ember-data and it will fail if you use anything else for client persistence.

## Installation

Add this line to your application's Gemfile:

    gem 'rails_ember_validations'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_ember_validations

## Usage
GENERAL



Just make a post request at /validate.json , passing your params as {"object_to_validate"=>{"attr1"=>"something", "attr2"=>"something",... }}

Example:

{"user"=>{"role"=>"administrator", "name"=>"User1", "id"=>"1"}}

If you sent an id in object's attributes ,server will validate it as new, else as update.

Server will validate ANY attribute , based on validations defined in the appropriate model.
Server will also authorize your object (using CanCan's authorize! method), if you use CanCan, else it will just proceed 
in  validation check.

Responce for validation errors will be : {"attr1"=> [array_of_errors_for_attr1], "attr2"=> [array_of_errors_for_attr2],... }}

Example:

{"password":["can't be blank","Weak Password"],"name":["can't be blank"]}

EMBER.JS



Simply include App.ValidationView at the top of your form.



Include any input you may have in a div with id {attribute}Validation
To see the error , call view.{attribute}Validation in an if view.{attribute}Validation block

Authorization errors are displayed by calling view.authorizationValidation in an if view.authorizationValidation block.

For example in the following form we get authorization errors at the top of our form and validation errors for name attribute spanned to our input element . 

{{#view App.ValidationView }}
	{{#if view.authorizationValidation}}
		<div class="alert alert-error">
			{{view.authorizationValidation}}
		</div>

	{{/if}}

	<div id="nameInput" class="form-group">

		<span>First Name </span>

		{{input value=email type="text"}}

		{{#if view.nameValidation}}
			<div class="alert alert-error">
				{{view.nameValidation}}
			</div>

		{{/if}}		
	</div>

{{/view}}


When server returns errors (if any) , validationView will try to find divs with id named after the error attributes.
It will add 'has-error' class at them, so if you'd like you can overide this class' styling .

If server returns no errors, view will trigger the save action of current controller, so place any logic following a valid request there.
ValidationView also comes with a cancel action embedded that rollsback any changes to record you were editing or deletes it if it was new.













## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

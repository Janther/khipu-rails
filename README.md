# KhipuRails

[![Gem Version](https://badge.fury.io/rb/khipu-rails.svg)](http://badge.fury.io/rb/khipu-rails)
[![Dependency Status](https://gemnasium.com/Janther/khipu-rails.svg)](https://gemnasium.com/Janther/khipu-rails)

[Khipu](https://khipu.com/home) is a service that facilitates web billing and collection in **Chile**.

It handles very elegantly bank transfers and allows to generate bills in batches.
It offers an API for developers to create via POST new charges.

## Installation

Add to your Gemfile and run the `bundle` command to install it.
```ruby
gem 'khipu-rails'
```

If you want to work with the gem in development, you can allways use the git repository.
```ruby
gem 'khipu-rails', :git => "http://github.com/Janther/khipu-rails"
```

## Configuration
```ruby
KhipuRails.configure do |config|
  ##
  # Use receivers to set one or more receivers to the gem.
  # #add_receiver has 3 parameters, receiver_id, receiver_key, and receiver_mode(:dev|:pro)
  ##
  config.add_receiver "receiver1_id", "receiver1_key", :dev
  config.add_receiver "receiver2_id", "receiver2_key", :pro
                      ...

  ##
  # Use button_images to set one or more urls for the custom button images you might have.
  # Khipu's images are already registered.
  # Each button image is key/value pair
  # The same as with the receivers registration, use this method as a shortcut for long urls on your view.
  ##
  config.button_images.merge! :shortcut => "url"

  ##
  # The hash defaults can also be modified, giving you control of the default values the helper khipu_button uses.
  ##
  config.button_defaults.merge! :variable_name => variable_value
end
```
*receiver_id and receiver_key can be found [here](https://khipu.com/merchant/profile#instant-notification-data)*

# Features

## Creating a button for a single bill

This gem provides a helper to build a button using the right parameters provided in the [API documentation](https://khipu.com/page/api#creacion-formulario).

### khipu_button
**khipu_button subject, amount, options = {}**

Params:
* **subject**: The subject of the bill. *(max 255 chars)*
* **amount**: Amount to charge.

Options:
* **:body**: Further description of the charge.
* **:return_url**: callback URL to specify to the browser once the payment is comlpeted.
* **:cancel_url**: callback URL to specify to the browser if the user decides not to proceed with the transaction.
* **:transaction_id**: additional identifier related to the transaction.
* **:payer_email**: The email of the payer. If this is set, Khipu will pre-fill this field in the payment page.
* **:picture_url**: The URL of the product or service related to this charge.
* **:custom**: Additional information related to this charge such as shipment instructions.
* **:button_image**: Identifier of the button to display. If you designed your own button you can also provide the URL. *(It defaults to __"50x25"__ when __nil__ given)*
* **:receiver_id**: You can specify a receiver if you don't want to use the data stored in the **KhipuRails::Config.user_id** variable.
* **:secret**: You can specify a secret if you don't want to use the data stored in the **KhipuRails::Config.api_key** variable.

**[Button Images provided by Khipu](https://khipu.com/page/botones-de-pago)**

**50x25**: ![50x25 Button](https://s3.amazonaws.com/static.khipu.com/buttons/50x25.png)

**100x25**: ![100x25 Button](https://s3.amazonaws.com/static.khipu.com/buttons/100x25.png)

**100x50**: ![100x50 Button](https://s3.amazonaws.com/static.khipu.com/buttons/100x50.png)

**150x25**: ![150x25 Button](https://s3.amazonaws.com/static.khipu.com/buttons/150x25.png)

**150x50**: ![150x50 Button](https://s3.amazonaws.com/static.khipu.com/buttons/150x50.png)

**150x75**: ![150x75 Button](https://s3.amazonaws.com/static.khipu.com/buttons/150x75.png)

**150x75-B**: ![150x75-B Button](https://s3.amazonaws.com/static.khipu.com/buttons/150x75-B.png)

**200x50**: ![200x50 Button](https://s3.amazonaws.com/static.khipu.com/buttons/200x50.png)

**200x75**: ![200x75 Button](https://s3.amazonaws.com/static.khipu.com/buttons/200x75.png)

## Validation of payment notifications *(Waiting for Khipu to release developer accounts.)*

If you provide an URL for Khipu to deliver [notifications](https://khipu.com/page/api#notification-instantanea) on succesfull payments, this gem provides a validation method to prevent forgery of notifications.

### khipu_validation

**KhipuRails::NotificationValidator.is_valid? notification, mode = :local**

* **notification**: The POST params delivered by Khipu.
* **mode**: Whether the validation should be done at the **[:local](https://khipu.com/page/api#validacion-local)** or by **[:webservice](https://khipu.com/page/api#validacion-web-service)**.

# TODO:

## New Features

### khipu.js
**Khipu offers a JS library to interact with their API.**

This gem will have the JS integrated along helpers to help implementation.

### khipu_button v2
**khipu_button subject, amount, options = {}, &block**

Options:
* **:hash_url**: if provided the hash won't be generated by default and upon submit, it will be requested.
* **:form_options**: html options for the form.
* **:button_options**: html options for the button.

Block
&block: If a block is given the helper will render it within the form. This can be usefull for further customization of the form.

**If the block contains a submit input, a button or an image input, it won't render the image input provided by the helper.**

### khipu_hash
**khipu_hash options = {}**

Generator of the Khipu hash made public so you can include it in an action when **:hash_url** is given to the form.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

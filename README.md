# KhipuRails

[Khipu](https://khipu.com/home) is a service that facilitates web billing and collection in Chile.
It handles very elegantly bank transfers and allows to generate bills in batches.
It offers an API for developers to create via POST new charges.

## Installation

Add to your Gemfile and run the `bundle` command to install it.

```ruby
gem 'khipu-rails'
```
Create a khipu.yml file under your config folder.
```yaml
production:
  user_id: YOUR ID
  api_key: YOUR API KEY

test:
  user_id: YOUR ID
  api_key: YOUR API KEY

development:
  user_id: YOUR ID
  api_key: YOUR API KEY
```

*ID and API KEY can be found [here](https://khipu.com/merchant/profile#instant-notification-data)*

# TODO:

## Creating a button for a single bill

This gem provides a helper to build a button using the right parameters provided in the [API documentation](https://khipu.com/page/api#creacion-formulario).

### khipu_button
**khipu_button subject, amount, button_image = "50x25", OPTIONS**

Params:
* **subject**: The subject of the bill. *max 255 chars*
* **amount**: Amount to charge.
* **button_image**: Size of the [buttons provided by Khipu](https://khipu.com/page/botones-de-pago). If you designed your own button you can also provide the URL.

Options:
* **:body**: Further description of the charge.
* **:return_url**: callback URL to specify to the browser once the payment is comlpeted.
* **:cancel_url**: callback URL to specify to the browser if the user decides not to proceed with the transaction.
* **:transaction_id**: additional identifier related to the transaction.
* **:payer_email**: The email of the payer. If this is set, Khipu will pre-fill this field in the payment page.
* **:picture_url**: The URL of the product or service related to this charge.
* **:custom**: Additional information related to this charge such as shipment instructions.

## Validation of payment notifications

If you provide an URL for Khipu to deliver [notifications](https://khipu.com/page/api#notification-instantanea) on succesfull payments, this gem provides a validation method to prevent forgery of notifications.

### khipu_validation

**khipu_validation params, local_validation = false**

* **params**: The POST params delivered by Khipu.
* **local_validation**: Wether the should be done at the [local machine](https://khipu.com/page/api#validacion-local) or by [Khipu's API](https://khipu.com/page/api#validacion-web-service).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Stripe Webhook Events Task

We want to the ability to receive, store and query stripe events that are sent as webhooks (https://stripe.com/docs/webhooks)

## Sample Event Payload

```
{
  "created": 1326853478,
  "livemode": false,
  "id": "evt_00000000000000",
  "type": "customer.deleted",
  "object": "event",
  "request": null,
  "pending_webhooks": 1,
  "api_version": "2017-04-06",
  "data": {
    "object": {
      "id": "cus_00000000000000",
      "object": "customer",
      "account_balance": 0,
      "created": 1495156631,
      "currency": "usd",
      "default_source": null,
      "delinquent": false,
      "description": null,
      "discount": null,
      "email": null,
      "livemode": false,
      "metadata": {
      },
      "shipping": null,
      "sources": {
        "object": "list",
        "data": [

        ],
        "has_more": false,
        "total_count": 0,
        "url": "/v1/customers/cus_AgMSt8deigtv8x/sources"
      },
      "subscriptions": {
        "object": "list",
        "data": [

        ],
        "has_more": false,
        "total_count": 0,
        "url": "/v1/customers/cus_AgMSt8deigtv8x/subscriptions"
      }
    }
  }
}
```

## Controller Endpoint

We want a controller endpoint at `/webhook/stripe_events`. Please create the route in the `routes.rb` file. The controller file already exists as `Webhook::StripeEventsController`

The job of the controller is to:

1. Verify the signature of the request (https://stripe.com/docs/webhooks#signatures)
2. Queue a Sidekiq worker (`StripeEventProcessor`) that will process the event asynchronously.
3. Return a 200 response if the job was successfully queued. Otherwise return the appropriate HTTP error code.

## Background Worker

The job of the worker (`StripeEventProcessor`) is to save the event payload in the database (in the `Webhook::Stripe::Event` model) if it doesn't already exist. 

Additionally, if we receive a `charge.failed` event, we want to queue the `FailedPaymentEmailer` background job with the `id` of the saved model (there is no need to implement this worker, just queue)



## ActiveRecord Model

You will create a model called `Webhook::Stripe::Event` to save the data from the webhooks. The model will have (at least) the following fields:

* `stripe_id`
* `event_type`
* `timestamp`
* `data`

We want to be able to query the model by `stripe_id`, filter by `event_type` and sort by the `timestamp`

Write the appropriate migrations (including indices), validations and scopes for the model. 



## Further Instructions

* Normally you would save credentials such as API keys outside of source control but for the purpose of this task, feel free to hardcode these
* Write the tests you think are most appropriate e.g. would give you the confidence to open a pull request
* When you are done, create a pull request on github

## Helpful Resources

* Tunnel into localhost using ngrok (https://ngrok.com/)
* Sidekiq wiki (https://github.com/mperham/sidekiq/wiki)
* Stripe ruby docs (https://stripe.com/docs/api/ruby#intro)
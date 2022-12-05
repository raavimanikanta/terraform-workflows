// Create a policy to track
resource "newrelic_alert_policy" "my-policy" {
  name = "workflow-policy"
}

data "newrelic_entity" "app" {
  name = "FoodMe"
  type = "APPLICATION"
  domain = "APM"
}

resource "newrelic_alert_condition" "condition_1" {
  policy_id = newrelic_alert_policy.my-policy.id

  name        = "workflow-alert-condition"
  type        = "apm_app_metric"
  entities    = [data.newrelic_entity.app.application_id]
  metric      = "apdex"
  runbook_url = "https://www.example.com"
  condition_scope = "application"

  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = "0.75"
    time_function = "all"
  }
}



// Create a reusable notification destination
resource "newrelic_notification_destination" "webhook-destination" {
  name = "notification-destination"
  type = "EMAIL"

  property {
    key = "email"
    value ="raavimani123@gmail.com"
  }

  auth_basic {
    user = "username"
    password = "password"
  }
}

// Create a notification channel to use in the workflow
resource "newrelic_notification_channel" "example-channel" {
  name = "notification-channel"
  type = "EMAIL"
  destination_id = newrelic_notification_destination.webhook-destination.id
  product = "IINT" // Please note the product used!

  property {
    key = "payload"
    value = "{}"
    label = "Payload Template"
  }
}

resource "newrelic_workflow" "workflow-example" {
  name = "workflow-example-demo"
  muting_rules_handling = "NOTIFY_ALL_ISSUES"

  issues_filter {
    name = "Filter-name"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator = "EXACTLY_MATCHES"
      values = [ newrelic_alert_policy.my-policy.id ]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.example-channel.id
  }
}
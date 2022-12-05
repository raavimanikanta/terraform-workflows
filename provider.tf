# Configure terraform
terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
    }
  }
}

# Configure the New Relic provider
provider "newrelic" {
  account_id = 3627500
  api_key ="NRAK-FZKXTGUFO7E9OSQBIBX0GH3S9Z7"     # Usually prefixed with 'NRAK'
  region = "US"                    # Valid regions are US and EU
}
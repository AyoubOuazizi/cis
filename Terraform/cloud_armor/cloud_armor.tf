provider "google" {
  credentials = file("../../Credentials/cis-key.json")
  project     = "cis-project-411615"
  region      = "us-central1"
}

resource "google_compute_security_policy" "juice-shop-cloud-armor-policy" {
  name        = "juice-shop-cloud-armor-policy"
  description = "Security policy for Juice Shop with Cloud Armor"
  project     = "cis-project-411615"
  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable = true
    }
  }

  # Rule to block all traffic
  # rule {
  #   action   = "deny(403)"
  #   priority = "100"
  #   match {
  #     versioned_expr = "SRC_IPS_V1"
  #     config {
  #       src_ip_ranges = ["*"]
  #     }
  #   }
  #   description = "Block all traffic"
  # }

  # Default Allow Rule
  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default Allow Rule"
  }

  dynamic "rule" {
    for_each = var.owasp_rules
    content {
      preview     = var.preview_mode
      action      = var.action
      priority    = rule.value.priority
      description = rule.value.description

      match {
        expr {
          expression = rule.value.expression
        }
      }
    }
  }
}


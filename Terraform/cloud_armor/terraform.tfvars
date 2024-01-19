owasp_rules = {
  sqli_rule = {
    priority   = "1000"
    expression = "evaluatePreconfiguredWaf('sqli-v33-stable', {'sensitivity': 1})"
    description = "owasp_rules for sqli injection"
  }
  
  xss_rule={
    priority   = "1001"
    expression = "evaluatePreconfiguredWaf('xss-v33-stable', {'sensitivity': 1})"
    description = "owasp_rules for cross site scripting"
  }

  # Local File Inclusion (LFI)
  lfi_rule = {
    priority   = "1002"
    expression = "evaluatePreconfiguredWaf('lfi-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for local file inclusion"
  }

  # Remote File Inclusion (RFI)
  rfi_rule = {
    priority   = "1003"
    expression = "evaluatePreconfiguredWaf('rfi-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for remote file inclusion"
  }

  # Remote Code Execution (RCE)
  rce_rule = {
    priority   = "1004"
    expression = "evaluatePreconfiguredWaf('rce-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for remote code execution"
  }

  # Method Enforcement
  method_enforcement_rule = {
    priority   = "1005"
    expression = "evaluatePreconfiguredWaf('methodenforcement-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for method enforcement"
  }

  # Scanner Detection
  scanner_detection_rule = {
    priority   = "1006"
    expression = "evaluatePreconfiguredWaf('scannerdetection-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for scanner detection"
  }

  # Protocol Attack
  protocol_attack_rule = {
    priority   = "1007"
    expression = "evaluatePreconfiguredWaf('protocolattack-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for protocol attack"
  }

  # PHP Injection Attack
  php_injection_rule = {
    priority   = "1008"
    expression = "evaluatePreconfiguredWaf('php-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for PHP injection attack"
  }

  # Session Fixation Attack
  session_fixation_rule = {
    priority   = "1009"
    expression = "evaluatePreconfiguredWaf('sessionfixation-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for session fixation attack"
  }

  # Java Attack
  java_attack_rule = {
    priority   = "1010"
    expression = "evaluatePreconfiguredWaf('java-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for Java attack"
  }

  # NodeJS Attack
  nodejs_attack_rule = {
    priority   = "1011"
    expression = "evaluatePreconfiguredWaf('nodejs-v33-stable', {'sensitivity': 1})"
    description = "OWASP rules for NodeJS attack"
  }

  # Newly Discovered Vulnerabilities (CVE Canary)
  cve_canary_rule = {
    priority   = "1012"
    expression = "evaluatePreconfiguredWaf('cve-canary', {'sensitivity': 1})"
    description = "OWASP rules for newly discovered vulnerabilities (CVE Canary)"
  }
  # Add other rules as needed
}
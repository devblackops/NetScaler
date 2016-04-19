@(
    @("CSAction",                              "csaction",                          "content switching action"),
    @("CSPolicy",                              "cspolicy",                          "content switching policy"),
    @("CSVirtualServer",                       "csvserver",                         "content switching virtual server"),
    @("RewriteAction",                         "rewriteaction",                     "rewrite action"),
    @("RewritePolicy",                         "rewritepolicy",                     "rewrite policy"),
    @("SAMLAuthenticationAction",              "authenticationsamlaction",          "SAML authentication action"),
    @("SAMLAuthenticationPolicy",              "authenticationsamlpolicy",          "SAML authentication policy"),
    @("VPNVirtualServer",                      "vpnvserver",                        "VPN virtual server"),
    @("VPNSessionAction",                      "vpnsessionaction",                  "VPN session action"),
    @("VPNSessionPolicy",                      "vpnsessionpolicy",                  "VPN session policy"),
    @("VPNSessionPolicy",                      "vpnsessionpolicy",                  "VPN session policy"),
    @("SSLCertificateKey",                     "sslcertkey",                        "SSL certificate key"),
    @("NTPServer",                             "ntpserver",                         "NTP server")
    
    #@("LBVirtualServerResponderPolicyBinding", "lbvserver_responderpolicy_binding", "load balancer server responder policy binding"),
    #@("LBVirtualServerRewritePolicyBinding",   "lbvserver_rewritepolicy_binding",   "load balancer server rewrite policy binding")
) | % {
    Contrib\New-GetCmdlet -Name $_[0] -Type $_[1] -Label $_[2]
    echo "Get-NS$($_[0]) | Measure"
}



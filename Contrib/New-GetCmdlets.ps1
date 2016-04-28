# This file is used to generate generic Get-* methods.
# It is used only once to generate the code and is kept here only if some of those methods had to
# be regerenerated.

# Format: @(<cmdlet name>, <resource type>, <documentation label>,
#            <optional hashtable of parameter names to a hashtable of filter name to parameter label>
#         )

@(
    @("CSAction",                              "csaction",                          "content switching action",
        @{
            "ActionName"      = @("name", "action name") 
            "TargetLBVserver" = @("targetlbvserver", "target load balancer virtual server") 
            "Hits"            = @("hits", "hits")
            "UndefinedHits"   = @("undefhits", "undefined hits")
            "ReferenceCount"  = @("referencecount", "reference count")
            "Comment"         = @("comment", "comment")
        }
    ),
    @("CSPolicy",                              "cspolicy",                          "content switching policy",
        @{
            #policyname:/a/,action:/b/,logaction:/a/,url:/a/,rule:/a/,domain:/a/
            "PolicyName"      = @("policyname", "policy name") 
            "Action"          = @("action", "action name") 
            "LogAction"       = @("logaction", "log action name")
            "Url"             = @("url", "URL")
            "Rule"            = @("rule", "rule")
            "Domain"          = @("domain", "domain")
        }
    
    ),
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
    Contrib\New-GetCmdlet -Name $_[0] -Type $_[1] -Label $_[2] -Filters $_[3]
    echo "Get-NS$($_[0]) | Measure"
}



# This file is used to generate generic Get-* methods.
# It is used only once to generate the code and is kept here only if some of those methods had to
# be regerenerated.

# Format: @(<cmdlet name>, <resource type>, <documentation label>,
#            <optional hashtable of parameter names to a hashtable of filter name to parameter label>
#         )

@(
    @("CSAction",                              "csaction",                          "content switching action",
        [ordered]@{
            "ActionName"      = @("name", "action name") 
            "TargetLBVserver" = @("targetlbvserver", "target load balancer virtual server") 
            "Hits"            = @("hits", "hits")
            "UndefinedHits"   = @("undefhits", "undefined hits")
            "ReferenceCount"  = @("referencecount", "reference count")
            "Comment"         = @("comment", "comment")
        }
    ),
    @("CSPolicy",                              "cspolicy",                          "content switching policy",
        [ordered]@{
            "PolicyName"      = @("policyname", "policy name") 
            "Action"          = @("action", "action name") 
            "LogAction"       = @("logaction", "log action name")
            "Url"             = @("url", "URL")
            "Rule"            = @("rule", "rule")
            "Domain"          = @("domain", "domain")
        }    
    ),
    @("CSVirtualServer",                       "csvserver",                         "content switching virtual server",
        [ordered]@{
            "ServerName"      = @("name", "virtual server name") 
            "CurrentState"    = @("curstate", "current state") 
            "IPv46"           = @("ipv46", "IPv4 or IPv6 address")
            "Port"            = @("port", "port")
            "ServiceType"     = @("servicetype", "service type")
            "TrafficDomain"   = @("td", "traffic domain")
            "TargetType"      = @("targettype", "target type")
        }    
    ),
    @("RewriteAction",                         "rewriteaction",                     "rewrite action",
        [ordered]@{
            "ActionName"        = @("name", "action name") 
            "Type"              = @("type", "type") 
            "Target"            = @("target", "target") 
            "Expression"        = @("stringbuilderexpr", "")
            "Pattern"           = @("pattern", "pattern")
            "Hits"              = @("hits", "hits")
            "UndefinedHits"     = @("undefhits", "undefined hits")
            "ShowBuiltin"       = @("isdefault", $Null, "default", "false")
        }
    ),
    @("RewritePolicy",                         "rewritepolicy",                     "rewrite policy"
        # name:/a/,rule:/a/,action:/a/,undefaction:/a/,hits:/a/,undefhits:/a/,isdefault:false
        [ordered]@{
            "PolicyName"        = @("name", "rewrite policy name") 
            "Rule"              = @("rule", "rule") 
            "Action"            = @("action", "action") 
            "UndefinedAction"   = @("undefaction", "undefined action")
            "Hits"              = @("hits", "hits")
            "UndefinedHits"     = @("undefhits", "undefined hits")
            "ShowBuiltin"       = @("isdefault", $Null, "default", "false")
        }
    ),
    @("ResponderPolicy",                       "responderpolicy",                   "responder policy"
        [ordered]@{
            "PolicyName"        = @("name", "responder policy name") 
            "Rule"              = @("rule", "rule") 
            "Action"            = @("action", "action") 
            "UndefinedAction"   = @("undefaction", "undefined action")
            "Hits"              = @("hits", "hits")
            "UndefinedHits"     = @("undefhits", "undefined hits")
            "ShowBuiltin"       = @("builtin", $Null, "default", "/^[^I]/")
        }
    ),
    @("SAMLAuthenticationServer",              "authenticationsamlaction",          "SAML authentication server"
        [ordered]@{
            "ServerName"         = @("name", "SAML authentication server name") 
            "IDPCertificateName" = @("samlidpcertname", "SAML IDP certificate name") 
            "RedirectUrl"        = @("samlredirecturl", "SAML redirect URL") 
        }    
    ),
    @("SAMLAuthenticationPolicy",              "authenticationsamlpolicy",          "SAML authentication policy"
        [ordered]@{
            "PolicyName"        = @("name", "SAML authentication policy name") 
            "Rule"              = @("rule", "rule") 
            "Server"            = @("reqaction", "SAML authentication server") 
        }    
    ),
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



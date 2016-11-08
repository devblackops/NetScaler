# This file is used to generate generic Get-* methods.
# It is used only once to generate the code and is kept here only if some of those methods had to
# be regerenerated.

# Format: @(<cmdlet name>, <resource type>, <documentation label>,
#            <optional hashtable of parameter names to a hashtable of filter name to parameter label>
#         ), <optional boolean that indicates arguments instead of filters>

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
    @("VPNVirtualServer",                      "vpnvserver",                        "VPN virtual server"
        [ordered]@{
            "ServerName"        = @("name", "virtual server name") 
            "CurrentState"      = @("curstate", "virtual server current state") 
            "IPv46"             = @("ipv46", "IPv4 or IPv6 address")
            "Port"              = @("port", "port")
            "ServiceType"       = @("servicetype", "service type")
            "MaxAAAUsers"       = @("maxaaausers", "max AAA users")
            "CurrentAAAUsers"   = @("curaaausers", "current AAA users")
            "CurrentTotalUsers" = @("curtotalusers", "current total users")
        }    
    ),
    @("VPNSessionProfile",                      "vpnsessionaction",                  "VPN session profile"
        [ordered]@{
            "ProfileName"       = @("name", "profile name") 
        }
    ),
    @("VPNSessionPolicy",                      "vpnsessionpolicy",                  "VPN session policy"
        [ordered]@{
            "PolicyName"        = @("name", "policy name") 
        }
    ),
    @("SSLCertificate",                        "sslcertkey",                        "SSL certificate"
        [ordered]@{
            "CertificateName"        = @("certkey", "certificate name") 
            "DayToExpiration"        = @("daystoexpiration", "days to expiration") 
            "Status"                 = @("status", "status") 
        }
    ),
    @("NTPServer",                             "ntpserver",                         "NTP server"
        [ordered]@{
            "ServerName"             = @("servername", "NTP server name") 
            "PreferredNTPServer"     = @("preferredntpserver", "preferred NTP server") 
        }
    ),
    @("KCDAccount",                            "aaakcdaccount",                     "KCD account"
        [ordered]@{
            "AccountName"            = @("kcdaccount", "KCD account name") 
            "Keytab"                 = @("keytab", "keytab") 
            "KCDSPN"                 = @("kcdspn", "KCD service principal name") 
            "Realm"                  = @("realmstr", "Realm") 
        }
    ),
    @("AAAVirtualServer",                     "authenticationvserver",             "Authentication virtual server"
        [ordered]@{}
    ),
    @("IPResource",                           "nsip",                              "IPv46 resource"
        [ordered]@{
            "IPAddress"             = @("ipaddress", "IPv4 address") 
            "State"                 = @("state", "state") 
            "Arp"                   = @("arp", "ARP") 
            "Icmp"                  = @("icmp", "ICMP") 
            "VirtualServer"         = @("vserver", "virtual server") 
            "TrafficDomain"         = @("td", "traffic domain") 
        }
    ),    
    @("IP6Resource",                          "nsip6",                             "IPv6 resource"
        [ordered]@{
            "IPAddress"             = @("ipv6address", "IPv6 address") 
            "State"                 = @("curstate", "state") 
            "Type"                  = @("iptype", "IP type") 
            "Scope"                 = @("scope", "scope") 
            "MappedIP"              = @("map", "mapped IP") 
            "TrafficDomain"         = @("td", "traffic domain") 
        }
    ),
    @("SystemFile",                          "systemfile",                         "system file"
        [ordered]@{
            "FileLocation"          = @("filelocation", "file location") 
            "Filename"              = @("filename", "file name")
        }, $True
    )
    # The following Get cmdlet has been modified after generation!
    #@("VirtualServerCertificateBinding",   "sslvserver_sslcertkey_binding",      "virtual server certificate-key pair binding"
    #    [ordered]@{}
    #)  
      
    #@("LBVirtualServerResponderPolicyBinding", "lbvserver_responderpolicy_binding", "load balancer server responder policy binding"),
    #@("LBVirtualServerRewritePolicyBinding",   "lbvserver_rewritepolicy_binding",   "load balancer server rewrite policy binding")
) | % {
    $Name, $Type, $Label, $Filters, $Arguments = $_
    echo "Get-NS$($Name) | Measure -Count"
    Contrib\New-GetCmdlet -Name $Name -Type $Type -Label $Label -Filters $Filters -Arguments:$Arguments
}



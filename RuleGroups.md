AWS WAF Bot Control offers you protection against automated bots that can consume excess resources, skew business metrics, cause downtime, or perform malicious activities. Bot Control provides additional visibility through Amazon CloudWatch and generates labels that you can use to control bot traffic to your applications


Admin Protection - 100 capacity
Contains rules that allow you to block external access to exposed admin pages. This may be useful if you are running third-party software or would like to reduce the risk of a malicious actor gaining administrative access to your application.

Amazon IP reputation list - 25 Capacity
This group contains rules that are based on Amazon threat intelligence. This is useful if you would like to block sources associated with bots or other threats.

Anonymous IP list - 50 capacity
This group contains rules that allow you to block requests from services that allow obfuscation of viewer identity. This can include request originating from VPN, proxies, Tor nodes, and hosting providers. This is useful if you want to filter out viewers that may be trying to hide their identity from your application.

Core rule set - 700 capacity
Contains rules that are generally applicable to web applications. This provides protection against exploitation of a wide range of vulnerabilities, including those described in OWASP publications.

SQL database - 200 capacity
Contains rules that allow you to block request patterns associated with exploitation of SQL databases, like SQL injection attacks. This can help prevent remote injection of unauthorized queries.


Here are the rule action options:

Count – AWS WAF counts the request but doesn't determine whether to allow it or block it. With this action, AWS WAF continues processing the remaining rules in the web ACL. You can insert custom headers into the request and you can add labels that other rules can match against.


Allow – AWS WAF allows the request to be forwarded to the protected AWS resource for processing and response. You can insert custom headers into the request before forwarding it to the protected resource.


Block – AWS WAF blocks the request. By default, the AWS resource responds with an HTTP 403 (Forbidden) status code, but you can customize the response. When AWS WAF blocks a request, the block action settings determine the response that the protected resource sends back to the client.
For information about customizing requests and responses, see Customizing web requests and responses in AWS WAF.

For information about adding labels to matching requests, see AWS WAF labels on web requests.

You can override rule actions when you add them to a web ACL. When you do this, the rule runs with the action set to count. For more information about how web ACL and rule settings interact, see Web ACL rule and rule group evaluation.
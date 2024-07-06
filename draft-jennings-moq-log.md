%%%
title = "Logging over Media over QUIC Transport"
abbrev = "moqt-log"
ipr= "trust200902"
area = "transport"
workgroup = ""
keyword = ["realtime","quicr"]

[seriesInfo]
status = "informational"
name = "Internet-Draft"
value = "draft-jennings-moq-log"
stream = "IETF"

[[author]]
initials="C."
surname="Jennings"
fullname="Cullen Jennings"
organization = "cisco"
[author.address]
email = "fluffy@iii.ca"
[author.address.postal]
country = "Canada"

%%%

.# Abstract

This species how to send syslog (RFC5424) type information over MoQT.

{mainmatter}

# Introduction 

The basic idea is each device that was logging would publish each log
message as an object. The URLs for the objects would be set up such that
a subscriber could subscribe to each device creating logs separately,
and could pick the log priority level in the subscriptions.

# Terminology

## Resource ID

Each device that creates logs has a unique deviceID. This is created by
taking the MAC address of the primary network interface in binary,
computing the sha1 hash of it, and truncating to lower 64 bits. Note the
sha1 does not provide any security priories, it is just a hash that is
widely implemented in hardware. If this is not possible, any other
random stable 64 bit identifier may be used. The advantage of us MAC
address is that many other management systems use this address and it
makes it easier to correlate. The disadvantage is that it reveals the
MAC address.


# Naming

The Namespace used is "moq://moq-syslog.arpa/logs-v1/"

The Track name used is the binary deviceID followed by a single byte
that has the log priority level in binary. Following 

~~~
 <resourceId>/<log_level>
 
~~~

The GroupId is timestamp in the message truncated to at 62 bit
binary integer.

The object number is zero unless more than one message is produced in
the same microseconds in which case they will each get their own object
number.


# Object Data

The object is a JSON object with the following fields:

pri: As defined in RFC5424. 

timestamp: single integer with number of microseconds since "1 Jan 1972"
using NTP Era zero conventions.

version: 1 ( As defined in RFC5424.  ) 

hostname: As defined in RFC5424. Note this might not be a hostname. 

appname: As defined in RFC5424. 

procid: As defined in RFC5424. 

msgid: As defined in RFC5424. 

msg: As defined in RFC5424. 

Any other fields are treated as structured data as defined in rfc5424. 

# Example

On 31 Dec 1999 UTC a server produces the log message "shutting down for
Y2K" The timestamp for this would be 3,155,587,200.

{backmatter}

# Acknowledgments

Thanks to TODO for contributions and suggestions to this
specification.


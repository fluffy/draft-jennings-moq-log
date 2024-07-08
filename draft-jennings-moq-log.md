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
organization = "Cisco"
[author.address]
email = "fluffy@iii.ca"
[author.address.postal]
country = "Canada"

%%%

.# Abstract

Real time systems often run into the problems where the network bandwidth
for logging in shared with the real time media and impacts the media
quality. There is a desire to transport the logging data at an
appropriate priority level over the same transport as the media. This
allows the logging data to take advantage of times when the media
bitrate is blow the peak rate while not impact the peak rate available
for media.

This document specifies how to send syslog RFC5424 type information over the
Media Over QUIC Transport (MOQT) [@!I-D.ietf-moq-transport].

{mainmatter}

# Introduction 

The idea is each device that was logging would publish each log message
as an MOQT object. The devices or systems publishing the logs are referred to
as resources and have an unique ResourceID. The URLs for the objects
would be set up such that a subscriber could subscribe to each resource
creating logs separately, and could pick the log priority level in the
subscriptions. The log collector would subscribe to the logs from
the appropriate Resources that the collector wished to monitor.

The data model used is consistent with the "OpenTelemetry
Specification" [@OTEL] (see
https://opentelemetry.io/docs/specs/otel/logs/data-model/) and a
superset of the [@!RFC5424] data model for logging.

[@!RFC5424]  specifies a layered architecture that provides for support
of any number of transport layer mappings for transmitting syslog
messages.  This document describes the MOQT transport mapping for the
syslog protocol.


# Terminology

## Resource ID {#sec-res-id}

Each Resource that creates logs has a unique resourceID. This is
created by taking the MAC address of the primary network interface in
binary, computing the SHA1 hash of it, then truncating to lower 64
bits. Note the SHA1 does not provide any security priories, it is just a
hash that is widely implemented in hardware. If this is not possible,
any other random stable 64 bit identifier may be used. The advantage of
us MAC address is that many other management systems use this address
and using it makes it easier to correlate with other systems. The
disadvantage is that it reveals the MAC address.


# Naming {#sec-naming}

The Namespace used is "moq://moq-syslog.arpa/logs-v1/"

The Track name used is the binary resourceID followed by a single byte
that has the log priority level in binary. Following the pattern:

~~~
 <resourceID>/<log_level>
~~~

The MOQT Group ID is timestamp (explain in the next section) in the message
truncated to a 62 bit binary integer.

The MOQT Object ID is zero unless more than one message is produced in
the same microseconds in which case they each will get their own object
number.


# Object Data  {#sec-obj-data}

The object payload is a JSON [@!RFC8259] object with the following optional fields:

* severity: As defined in [@!RFC5424]. Encoded as string "Emergency",
"Alert", ... "Debug". This is called ServerText in [@OTEL].

* timestamp: single integer with number of microseconds since "1 Jan 1972"
using NTP Era zero conventions.

* pri: As defined in [@!RFC5424]. Numeric value from 0 to 23 and default is 1
if not present.

* hostname: As defined in [@!RFC5424]. Note this might not be a hostname.

* appname: As defined in [@!RFC5424]. 

* procid: As defined in [@!RFC5424]. 

* msgid: As defined in [@!RFC5424]. 

* msg: As defined in [@!RFC5424]. This is a UTF-8 string. 

Any other fields are treated as structured data as defined in [@!RFC5424]
and include:

* TraceID: Used in [@OTEL] and defined in [@CRD-trace-context-2-20240328].

* SpanID: As defined in [@OTEL]. 

* InstrumentationScope: As defined in [@OTEL]. 

Any other fields are treated as "Attributes" when mapped to [@OTEL].

# IANA {#sec-iana}

TBD

# Security Considerations {#sec-security}

TBD

# Examples {#sec-examples}

On 31 Dec 1999 UTC a server produces the log message "shutting down for
Y2K" with severity INFO.  The timestamp for this would be
3,155,587,200. The JSON data would be:

```
{
   "timestamp":3155587200,
   "severity":"Info",
   "msg":"shutting down forY2K"
}
```

{backmatter}

# Acknowledgments

Thanks to Suhas Nandakumar and Tim Evens for contributions and
suggestions to this specification.


<reference anchor='CRD-trace-context-2-20240328'
           target='https://www.w3.org/TR/2024/CRD-trace-context-2-20240328/'>
  <front>
    <title>Trace Context Level 2</title>
    <author fullname='Sergey Kanzhelev' surname='Kanzhelev' initials='S.'/>
    <author fullname='Daniel Dyla' surname='Dyla' initials='D.'/>
    <author fullname='Yuri Shkuro' surname='Shkuro' initials='Y.'/>
    <author fullname='J. Kalyana Sundaram' surname='Sundaram' initials='J. K.'/>
    <author fullname='Bastian Krol' surname='Krol' initials='B.'/>
    <date year='2024' month='March' day='28'/>
  </front>
  <seriesInfo name='W3C' value='CRD-trace-context-2-20240328'/>
</reference>


<reference anchor='OTEL'
           target='https://opentelemetry.io/docs/specs/otel/logs/'>
  <front>
    <title>OpenTelemetry Specification 1.34.0</title>
     <author fullname='Armin Ruech' surname='Ruech' initials='A.'/>
    <date year='2024' month='June' day='11'/>
  </front>
</reference>




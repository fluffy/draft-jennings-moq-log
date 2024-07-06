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

Real time systems often run into the problem where the network bandwidth
for loggin in shared with the real time media and impacts the media
qaulity. There is a desire to transport the logging data an a aproperate
priority level over the same transport as the media. This allows the
logging data to take advantage of times when the media bitrate is blow
the peak rate while not impact the peak rate available for media.

This species how to send syslog (RFC5424) type information over the
Media Over Quic Transport (MoQT).

{mainmatter}

# Introduction 

The idea is each device that was logging would publish each log message
as an object. The devices or systems publishing the logs are refered
to as resrouces and have a unuiq ResourceID.
The URLs for the objects would be set up such that
a subscriber could subscribe to each resource creating logs separately,
and could pick the log priority level in the subscriptions.

The data model used is consistent with the the "OpenTelemetry
Specification 1.34.0" (TODO REF) (see
https://opentelemetry.io/docs/specs/otel/logs/data-model/) and a
superset of the RFC 5424 (TODO REF) data model for logging.


# Terminology

## Resource ID

Each Resources that creates logs has a unique resourceID. This is created by
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

The Track name used is the binary resourceID followed by a single byte
that has the log priority level in binary. Following 

~~~
 <resourceId>/<log_level>
~~~

The GroupId is timestamp (explain in the next section) in the message truncated to at 62 bit
binary integer.

The object number is zero unless more than one message is produced in
the same microseconds in which case they will each get their own object
number.


# Object Data

The object is a JSON object with the following optional fields:

severity: As defined in RFC5424. Encoded as string "Emergency",
""Alert", ... "Debug". This is called ServerText in OTel.

timestamp: single integer with number of microseconds since "1 Jan 1972"
using NTP Era zero conventions.

pri: As defined in RFC5424. Numeric value from 0 to 23 and default is 1 if not present.

hostname: As defined in RFC5424. Note this might not be a hostname. 

appname: As defined in RFC5424. 

procid: As defined in RFC5424. 

msgid: As defined in RFC5424. 

msg: As defined in RFC5424. This is a UTF-8 string. 

Any other fields are treated as structured data as defined in rfc5424 and inlcude:

TraceID: Used in OTel and defined in https://www.w3.org/TR/trace-context/#trace-id. TODO REF. 

SpanID: As defined in Otel. 

InstrumentationScope: As defined in OTel. 

Any other fields are treated as "Attributes" when mapped to OTel.


# Example

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

Thanks to TODO for contributions and suggestions to this
specification.


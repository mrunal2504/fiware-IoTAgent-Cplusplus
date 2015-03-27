# Southbound API
## Ultra Light Agent ###
Ultra-Light (UL20) is a HTTP protocol to send short data.
Previously, this module is configured in _/iot/d_ URI and the service provisioned has _apikey_ ('abc' in curl example). Parameters are:
You can send data with HTTP GET (it use query parameters):
```
curl -X GET 'http://127.0.0.1:8080/iot/d?i=dev_agus&d=t|15&k=abc' -i
```
- _i_: device identifier.
- _d_: data as key value separated by character |.
- _k_: apikey assigned to service.

Published entity is:
```
{"id":"thing:dev_agus","type":"thing","isPattern":"false","attributes":[{"name":"t","type":"","value":"15","metadatas":[{"name":"TimeInstant","type":"ISO8601","value":"2015-02-12T08:31:07.661697Z"}]},{"name":"TimeInstant","type":"ISO8601","value":"2015-02-12T08:31:07.661697Z"}]}
```

A value could be a paired value (like GPS position) following this format _a_/_b_.
You can send data with HTTP POST. With this option you can send multiple _data_ groups. Every group mus be separated by character #. One group is composed by _key_|_value_. Each group updates entity.
```
curl -X POST 'http://127.0.0.1:8080/iot/d?i=dev_agus&k=abc' \
     -i \
     -d 'gps|1.2/3.4#t|10'

```
Published entity is:
```
{"id":"thing:dev_agus","type":"thing","isPattern":"false","attributes":[{"name":"gps","type":"","value":"1.2/3.4","metadatas":[{"name":"TimeInstant","type":"ISO8601","value":"2015-02-12T08:34:21.738847Z"}]},{"name":"TimeInstant","type":"ISO8601","value":"2015-02-12T08:34:21.738847Z"}]}
```
and
```
{"id":"thing:dev_agus","type":"thing","isPattern":"false","attributes":[{"name":"t","type":"","value":"10","metadatas":[{"name":"TimeInstant","type":"ISO8601","value":"2015-02-12T08:41:54.864249Z"}]},{"name":"TimeInstant","type":"ISO8601","value":"2015-02-12T08:41:54.864249Z"}]}
```

You can review protocol reference in [Ultra-Light](UL20_protocol.md).

## MQTT Agent ###

## Thinking Things Agent ###
Thinking Things devices use their own frame format over HTTP requests to send measures and take configuration changes. Thinking Things module for IoTAgent will transform those HTTP request into ContextBroker entities following the mapping described here: [Thinking Things](TT_protocol.md). One key thing that differentiates Thinking Things from others protocols is that there is no "apikey" for identifying services. Users will need to provision a "sub-service" within the given Service. For doing so, they have to provide a "trust_token" as credentials.

Header for the service:
```
Fiware-Service:
```

And Sub-service:
```
Fiware-ServicePath:
```

Once the sub-service is successfully created, devices can be added to that service. The name of the device can be personalized by providing an "entity_name" header, same for "entity_type". These two fields will appear on the entity published on ContextBroker (see example below).

All devices will target the same URL and the stack-id that is included in the request is used internally to obtain the service and sub-service where that particular device belongs. The following example shows an example of the request sent by a device (note that part of the body is URL encoded) and how the entity published on ContextBroker looks like.  

```
curl -v http://10.0.2.15:8080/iot/tt -d cadena=%238934075379000039321%2C%230%2CGM%2Ctemp%2C25%2C20%24wakeUP
```

The body has the keyword "cadena=" and after that, the TT frame is URL encoded. For clarity this is what has been sent:
Stack-id: 8934075379000039321
Module: GM
Name: temp
value: 25
Sleep Condition: "wakeUp"
Sleep Time: 20



Published entity is:
```
{"id":"my_room","type":"thing","isPattern":"false","attributes":[{"name":"temp","type":"string","value":"25","metadatas":[{"name":"sleepcondition","type":"string","value":"wakeUP"},{"name":"sleeptime","type":"string","value":"20"},{"name":"TimeInstant","type":"ISO8601","value":"2015-03-20T08:52:22.235908Z"}]},{"name":"TimeInstant","type":"ISO8601","value":"2015-03-20T08:52:22.235908Z"}]}
```
Note that the stack-id is not directly published on ContextBroker but the entity_name given by the user when the device was provisioned, in this example :"my_room"

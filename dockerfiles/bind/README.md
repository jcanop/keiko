# ISC BIND DNS Server Docker Image
This project creates a Docker image of the [ISC BIND DNS Server](https://www.isc.org/bind/). The default configuration enables a DNS server forwarder that resolves using Google's and Quad9's public DNS servers.

## Execution Examples

### Run the default DNS server forwarder
~~~
$ docker run -p 53:53/udp -p53:53/tcp -d bind
~~~

### Run an authoritative DNS server
Here is an example configuration for an authoritative DNS server. Please keep in mind that this is an ***example***, and it's the minimal configuration for a test run. You should read the [BIND documentation](https://bind9.readthedocs.io/en/latest/#) and the [best practices](https://kb.isc.org/docs/bind-best-practices-recursive) for a production environment.

#### File: named.conf
~~~
options {
    directory "/var/bind";
    recursion no;
};

zone "example.com." {
    type master;
    file "/etc/bind/example.com.zone";
};
~~~

#### File: example.com.zone
~~~
$TTL 3600
example.com.     IN SOA dns.example.com. root.example.com. (80 3600 600 86400 600)
example.com.     IN NS  dns.example.com.
dns.example.com. IN A   10.0.0.1
www.example.com. IN A   10.0.0.2
ftp.example.com. CNAME  www.example.com.
~~~

#### Run the container
~~~
$ docker run -v $PWD:/etc/bind -p 53:53/udp -p 53:53/tcp -d bind
~~~

## Extract the RNDC Key
The image creates a default RNDC key. Use the following command to extract the key from the image. ***IMPORTANT***: you should not use this key for production; it's only for testing purposes.
~~~
$ id=$(docker run --rm -d bind); docker cp $id:/etc/bind/rndc.key .; docker stop $id
~~~

## ISC DNS Utilities
This image also contains the ISC DNS utilities, like dig. You can access these commands by calling the image and creating a temporary container.

~~~
$ docker run -ti bind dig www.google.com A
~~~

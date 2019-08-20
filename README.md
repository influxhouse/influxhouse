##### Requirements
- nodejs
- clickhouse

##### Installation

- `cd /opt`
- `git clone https://github.com/influxhouse/influxhouse.git`
- `cd influxhouse`
- `clickhouse-client -n < schema.sql`

##### Usage

- `node influxhouse.js`
- send metrics in influx line format by udp to 8089 port (for example: `echo 'foo,tag1=value1,tag2=value2 field1=12,field2=40' | nc -u localhost 8094`)

##### Systemd autostart script
- `sudo cp influxhouse.service /usr/lib/systemd/system/influxhouse.service`
- `sudo systemctl daemon-reload && systemctl enable influxhouse && systemctl start influxhouse`

##### License
MIT License.

##### See also

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

##### Systemd autostart script
- `sudo cp influxhouse.service /usr/lib/systemd/system/influxhouse.service`
- `sudo systemctl daemon-reload && systemctl enable influxhouse && systemctl start influxhouse`

##### License
MIT License.

##### See also

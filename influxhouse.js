const http = require('http');
const dgram = require('dgram');
const server = dgram.createSocket('udp4');

const fs = require('fs');
const url = require('url');

const util = require('util');

const config = JSON.parse(fs.readFileSync(__dirname + '/config.json'));

class Clickhouse {
    constructor() {
        this.schema = {};
        this.rows = {};
    }

    loadSchema() {
        return new Promise(async (resolve, reject) => {
            try {
                let tables = await this.select(`SHOW TABLES from ${config.clickhouse.db}`);
                for (let table in tables) {
                    let columns = await this.select(`DESCRIBE TABLE ${config.clickhouse.db}.${tables[table].name}`);
                    this.schema[tables[table].name] = {};
                    for (let column in columns) {
                        this.schema[tables[table].name][columns[column].name] = columns[column].type;
                    }

                    //console.log(columns);
                }

                //console.log(this.schema);
                resolve(this);

                //return res.end(JSON.stringify(tables, true, '\t'));
            } catch (e) {
                reject(e);
                //return res.end(e);
            }
        });
    }

    select(query) {
        return new Promise(async (resolve, reject) => {
            try {
                var resp = (response) => {
                    //console.log(util.inspect(response, {depth: 0}));

                    let rawData = '';
                    response.on('data', (chunk) => { rawData += chunk; });
                    response.on('end', () => {
                        let parsedData = JSON.parse(rawData.toString('utf8')).data;
                        //console.log(parsedData);
                        resolve(parsedData);
                    });
                };
                http.request(`${config.clickhouse.url}&query=${encodeURIComponent(query)}+FORMAT+JSON`, resp).end();
            } catch (e) {
                reject(e);
            }
        });

        //console.log(request);
    }

    exec(query) {

    }

    insert(table, rows) {

    }

    createTable(table, columns, indexes) {

    }

    addColumn (table, column, type) {

    }
}

const clickhouse = new Clickhouse();

class Influxhouse {
    constructor() {
        this.clickhouse = clickhouse;
    }

    async start() {
        await this.clickhouse.loadSchema();

        server.on('error', (err) => {
            console.log(`server error:\n${err.stack}`);
            server.close();
        });

        server.on('message', (message, rinfo) => {
            //let line = message.toString();

            //console.log(line);
            message.toString()
                .replace(/"(.*?)"/gim, '')
                .replace(/'(.*?)'/gim, '')
                .replace(/^([^,]+),([^ ]+) (.*) ([^ ]+)\n$/, function (s, measurement, tagString, valueString, time) {
                    time = time/1000000000;
                    let values = {}, types = {}, indexes = [];
                    values.time = time;
                    types.time = 'DateTime';
                    indexes.push('time');

                    types.host = 'String';
                    indexes.push('host');

                    let tagArray = tagString.split(",");
                    for (let tagIter in tagArray) {
                        let tagArrayAssoc = tagArray[tagIter].split("=");
                        let key = tagArrayAssoc[0], value = tagArrayAssoc[1];
                        //console.log([tagArrayAssoc[0], tagArrayAssoc[1]]);
                        if (!(key in values)) {
                            values[key] = value.toString();
                            types[key] = 'String';
                            if (key !== 'host') {
                                indexes.push(key);
                            }
                        }
                    }

                    let groupby = JSON.stringify(values);

                    let valueArray = valueString.split(",");
                    for (let valueIter in valueArray) {
                        let valueArrayAssoc = valueArray[valueIter].split("=");
                        let key = valueArrayAssoc[0], value = valueArrayAssoc[1];
                        //console.log([tagArrayAssoc[0], tagArrayAssoc[1]]);
                        if (!(key in values)) {
                            if (value in ['t', 'T', 'true', 'True', 'TRUE']) {
                                values[key] = true;
                                types[key] = 'UInt8';
                            } else if (value in ['FALSE', 'f', 'F', 'false', 'False', 'FALSE']) {
                                values[key] = false;
                                types[key] = 'UInt8';
                            } else if (value.substr(-1) === 'i') {
                                values[key] = parseInt(value.substr(0, value.length - 1));
                                types[key] = 'Int64';
                            } else if (value !== '') {
                                values[key] = parseFloat(value);
                                types[key] = 'Float64';
                            }
                            //console.log(values);

                            /*values[key] = value.toString();
                            types[key] = 'String';
                            if (key !== 'host') {
                                indexes.push(tagArrayAssoc[0]);
                            }*/
                        }
                    }

                    /*if (!('host' in values)) {
                        values.host = '';
                    }*/

                    if (!(measurement in clickhouse.rows)) {
                        clickhouse.rows[measurement] = {};
                    }

                    if (!(groupby in clickhouse.rows[measurement])) {
                        clickhouse.rows[measurement][groupby] = {};
                    }

                    if (measurement in clickhouse.schema) {

                        for (let key in types) {
                            if (!(key in clickhouse.schema[measurement])) {
                                clickhouse.addColumn(measurement, key, types[key]);
                                clickhouse.schema[measurement][key] = types[key];
                            }
                            clickhouse.rows[measurement][groupby][key] = values[key];
                        }
                    } else {
                        clickhouse.createTable(measurement , types, indexes);
                        clickhouse.schema[measurement] = types;
                        clickhouse.rows[measurement][groupby] = values;

                    }

                    //console.log([s, measurement, tagString, valueString, time]);
                });
            //console.log(line);
            //preg_match('|^([^,]+),([^ ]+) (.*) ([^ ]+)$|', $line, $matches);
        });

        server.on('listening', () => {
            const address = server.address();
            console.log(`server listening ${address.address}:${address.port}`);

            setInterval(function () {
                if (clickhouse.rows) {

                    let rows = '';

                    for (let measurement in clickhouse.rows) {
                        for (let groupby in clickhouse.rows[measurement]) {
                            rows = JSON.stringify(clickhouse.rows[measurement][groupby]) + '\n';
                        }
                    }

                    clickhouse.rows = {};

                    console.log(rows);return;
                    //let rows = clickhouse.rows
                    let post_options = {
                        host: clickhouseUrl.hostname,
                        port: clickhouseUrl.port,
                        path: clickhouseUrl.path + '&query=INSERT+INTO+' + config.clickhouseTable + '+FORMAT+JSONEachRow',
                        method: 'POST',
                        headers: {
                            'Content-Type': 'text/plain',
                            'Content-Length': Buffer.byteLength(rows)
                        }
                    };

                    var request = http.request(post_options);

                    //request.setNoDelay(true);
                    //request.on('data', function (chunk) {console.log('Response: ' + chunk);});
                    //request.on('error', (error) => {console.log(error);});
                    //request.on('response', (response) => {console.log(response);});
                    request.write(rows);
                    request.end();
                }
            }, config.timer * 1000);
        });

        server.bind(config.port, config.host);

        /*const server = http.createServer(async (req, res) => {
            res.writeHead(200, {'Content-Type': 'text/plain'});

            //console.log();
            //console.log(util.inspect(req, {depth: 0}));



            if (req.url != '/favicon.ico') {
                //clickhouse.select();
            }

            return res.end('ok');
        });


        server.listen(config.port, config.host);*/
    }
}



(new Influxhouse()).start();

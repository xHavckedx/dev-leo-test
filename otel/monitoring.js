'use strict'

const { MeterProvider } = require('@opentelemetry/metrics')
const meter = new MeterProvider().getMeter('example-meter')
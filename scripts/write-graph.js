const fs = require('fs')
const path = require('path')
const createGraph = require('./create-graph')

const data = require(path.join(__dirname, process.argv[2]))

let filename = process.argv[2]
if (!filename.endsWith('.json')) {
  filename += '.json'
}

fs.writeFileSync(
  path.join(__dirname, filename.slice(0, -5) + '.graph.json'),
  JSON.stringify(createGraph(data), null, 2)
)

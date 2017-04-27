const path = require('path')
const filename = process.argv[2]

const data = require(path.join(__dirname, filename + '.graph.json')).graph

const lispCode = Object.entries(data).map(([key, value]) => {
  return `(${key} (${value.join(' ')}))`
}).join(require('os').EOL)

require('fs').writeFileSync(path.join(__dirname, filename + '.lisp.txt'), lispCode)

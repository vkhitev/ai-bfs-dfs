const path = require('path')
const filename = process.argv[2]
const outname = process.argv[3]

const data = require(path.join(__dirname, filename + '.graph.json')).nodes
const R = require('ramda')
const fs = require('fs')
const os = require('os')
const unnamed = `0 1 2 3 4 5 6 19 7 20 8 21 9 22 10 11 12 27 28 13 26 29 14 25 30 15 24 37 31 16 23 32 17 33 18 34 35 36`.split(' ')

fs.writeFileSync(
  path.join(__dirname, outname),
  unnamed
    .map(R.prop(R.__, data))
    .join(os.EOL)
)

const { Set, Map } = require('immutable')

function idxGenerator () {
  let idx = -1
  return function next () {
    idx += 1
    return idx
  }
}

function graphFromList (list) {
  function indexedList (list) {
    const generateIdx = idxGenerator()
    const map = Map().asMutable()
    list.forEach(branch => {
      branch.forEach(station => {
        if (!map.has(station)) {
          map.set(station, generateIdx())
        }
      })
    })
    return map
  }

  function nodes (indexed) {
    const map = Map().asMutable()
    for (let [key, value] of indexed) {
      map.set(value, key)
    }
    return map
  }

  const indexed = indexedList(list)
  const graph = Map().asMutable()
  const namedGraph = Map().asMutable()
  list.forEach(branch => {
    for (let i = 0; i < branch.length - 1; i++) {
      const from = indexed.get(branch[i])
      const to = indexed.get(branch[i + 1])
      const namedFrom = branch[i]
      const namedTo = branch[i + 1]
      if (!graph.has(from)) {
        namedGraph.set(namedFrom, Set().asMutable())
        graph.set(from, Set().asMutable())
      }
      if (!graph.has(to)) {
        namedGraph.set(namedTo, Set().asMutable())
        graph.set(to, Set().asMutable())
      }
      graph.get(from).add(to)
      graph.get(to).add(from)
      namedGraph.get(namedFrom).add(namedTo)
      namedGraph.get(namedTo).add(namedFrom)
    }
  })
  return { graph, namedGraph, nodes: nodes(indexed) }
}

module.exports = graphFromList

const { List } = require('immutable')

// dfs :: a → a → (a → Set a) → [a]
function dfs (initial, goal, expand) {
  const dfsi = (node, visited) => expand(node)
    .subtract(visited)
    .reduce((path, child) =>
      path.last() === goal ? path : dfsi(child, path),
      visited.push(node))
  return dfsi(initial, List())
}

module.exports = dfs

const { OrderedSet } = require('immutable')

// bfs :: a → a → (a → Set a) → Boolean
function bfs (initial, goal, expand) {
  const bfsi = (pending, tree) => {
    const newNodes = pending.flatMap(expand).subtract(tree)
    return pending.isEmpty() ? tree : bfsi(newNodes, tree.union(newNodes))
  }
  return bfsi(OrderedSet.of(initial), OrderedSet.of(initial))
}

module.exports = bfs

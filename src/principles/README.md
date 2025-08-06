# Principles

This section contains general principles to apply when developing Cardano nodes.

## Optimise only for the worst case

Algorithms often possess different performance characteristics in the best,
average and worst cases. Quick sort has, for example, `O(n*log(n))` time
complexity in the average case, but `O(n^2)` in the worst case.

Often in software we are interested in optimising for the average case, since
over time it tends to result in the highest overall performance. In Cardano,
however, we take a different approach: we want to only optimise the worst case
performance, and indeed, pick algorithms where _worst case is the same as best
(or average) case_.

### Motivation

There are two motivating ideas behind this principle:

1. _Performance will come to be relied upon_. This is an instance of Hyrum's
   law in action:

   > With a sufficient number of users of an API, it does not matter what you
   > promise in the contract: all observable behaviors of your system will be
   > depended on by somebody.

   If we manage to increase average performance, tools will be developed that
   come to expect this behaviour. If blocks can be processed faster, for
   example, there may be pressure to use that extra time to allow larger script
   execution budgets.

1. Forcing honest nodes to do more work provides an attack opportunity for the
   adversary. In the worst case, an adversary could potentially force nodes to
   fail to adopt or forge blocks, and hence potentially gain control of the
   chain.

### Example: UTxO locality

As an example, there is certain evidence that the UTxO set exhibits a degree of
temporal locality. That is, there are a number of long-lived UTxO entries that
are unlikely to be spent, while recently created entries are quite likely to
come up again.

We could choose to take advantage of this to organise the UTxO along the form
of a LRU (least recently used) cache. This would likely speed up UTxO lookup
in the average case, particularly were the UTxO stored on disk.

However, an attacker could then choose to deliberately craft a number of
transactions containing UTxO that were created a long time ago. A block filled
with such transactions, while being perfectly legitimate, might take
significantly longer to process than a regular block. The attacker could use
this delay to gain an advantage in block forging and thus magnify their
effective stake.

### Considerations

Whilst we have written the above as a general principle, there are of course
various considerations that effect how much we want to follow it:

1. The situation we most want to avoid is where an attacker could control an
   input such that they can force the worst-case behaviour. The UTxO locality
   example above is one such.
1. Still problematic are cases where an attacker cannot control the performance
   but can predict it, or less serious still, observe it. Either way a
   prepared attacker could take advantage of the degraded performance to launch
   an attack on the chain.
1. Either of these cases are exacerbated if the same behaviour is coordinated
   across all nodes, since this allows an attacker to exploit a performance
   drop across the entire network.

In situations where the inputs to a function are random or not observable by
an adversary, or where the effects are purely local, it may therefore still be
sensible to optimise for the average case. An example of such might be in
local state query computations, since these are triggered only by a (trusted)
local connection and do not lie on a critical path for block forging or
adoption.

The key point is that, in the Cardano setting, optimisations should be carefully
considered and it is certainly not the case that better average-case performance
is always desirable!

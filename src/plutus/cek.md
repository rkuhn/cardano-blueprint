# The CEK Machine

This page presents the operational semantics of the Plutus language using an abstract machine - a [CEK machine](https://en.wikipedia.org/wiki/CEK_Machine).
Although more complex than traditional reduction semantics, the CEK machine offers an efficient evaluation strategy that enables precise modeling of resource usage and cost.
The production Haskell evaluator is based on the CEK machine, and it also provides a practical foundation for alternative implementations.

The following listing defines some key concepts of the CEK machine.

```text
Σ ∈ State ::= 𝑠; 𝜌 ⊳ 𝑀   Computing M under environment 𝜌 with stack 𝑠
            | 𝑠 ⊲ 𝑉       Returning a value 𝑉 to stack 𝑠
            | ⬥          Throwing an error
            | ◻𝑉        Final state with result 𝑉

𝑠 ∈ Stack ::= 𝑓*  // A stack has zero or more stack frames

𝑉 ∈ CEK value ::= 〈con T 𝑐〉         A constant 𝑐 with type T
                | 〈delay 𝑀 𝜌〉       A delayed computation, with an
                                    associated environment
                | 〈lam 𝑥 𝑀 𝜌〉       A lambda abstraction, with an
                                    associated environment
                | 〈constr 𝑖 𝑉*〉      A constructor application, where
                                    all arguments are values
                | 〈builtin 𝑏 𝑉* 𝜂〉  A builtin application with all supplied
                                    arguments as values, and expecting
                                    at least one more argument

𝜌 ∈ Environment ::= []        An empty environment
                  | 𝜌[𝑥 ↦ 𝑉]  Associate 𝑥 with 𝑉 in the environment

𝜂 ∈ Expected builtin arguments ::= [𝜄]  // One argument
                                 | 𝜄⋅𝜂  // Two or more arguments

𝑓 ∈ Frame ::= (force _)    Awaiting a delayed computation to be forced
            | [_ (𝑀, 𝜌)]  An application awaiting the function, where the
                           argument is a term associated with an environment
            | [_ 𝑉]        An application awaiting the function, where the
                           argument is a value
            | [𝑉 _]        An application awaiting the argument, where the
                           function is a value
            | (constr 𝑖 𝑉* _ (𝑀*, 𝜌))  A constructor application awaiting
                                       an argument. The arguments before the hole
                                       are values, and the arguments after
                                       are terms to be evaluated.
            | (case _ (𝑀*, 𝜌))         A case expression awaiting the scrutinee
```

The CEK machine has two main kinds of states:

- `𝑠; 𝜌 ⊳ 𝑀` denotes evaluating term `𝑀` with environment `𝜌` and stack `𝑠`.
- `𝑠 ⊲ 𝑉` denotes returning a value `𝑉` to stack `𝑠`.

A value is a fully evaluated term, plus environments necessary for further computation.
An environment is a map binding variables to values.
A stack frame contains a hole to represent a pending value, and the context needed to continue evaluation once the value is received.
A builtin argument `𝜄` is either a term or a type argument.

To evaluate a Plutus program containing a term `𝑀`, the machine starts from state `[]; [] ⊳ 𝑀`, and based on the following transition table, proceeds as follows:

- If the current CEK machine state matches the From State, and the associated condition (if exists) is met, then the CEK machine transitions into the To State.
- If the machine arrives at state `◻𝑉`, the machine terminates with success, yielding the Plutus term corresponding to `𝑉` (which is essentially `𝑉` but with the environments removed) as final result.
- If the machine gets stuck (i.e., no rule applies) or arrives at state `⬥`, the evaluation terminates with a failure.

|         Rule         | From State                                        | To State                             | Condition              |
| :------------------: | :------------------------------------------------ | :----------------------------------- | :--------------------- |
|  <a href="#1">1</a>  | `𝑠; 𝜌 ⊳ 𝑥`                                        | `𝑠 ⊲ 𝜌[𝑥]`                           | 𝑥 is bound in 𝜌        |
|  <a href="#2">2</a>  | `𝑠; 𝜌 ⊳ (con T 𝑐)`                                | `𝑠 ⊲ 〈con T 𝑐〉`                    |                        |
|  <a href="#3">3</a>  | `𝑠; 𝜌 ⊳ (lam 𝑥 𝑀)`                                | `𝑠 ⊲ 〈lam 𝑥 𝑀 𝜌〉`                  |                        |
|  <a href="#4">4</a>  | `𝑠; 𝜌 ⊳ (delay 𝑀)`                                | `𝑠 ⊲ 〈delay 𝑀 𝜌〉`                  |                        |
|  <a href="#5">5</a>  | `𝑠; 𝜌 ⊳ (force 𝑀)`                                | `(force _)⋅𝑠; 𝜌 ⊳ 𝑀`                 |                        |
|  <a href="#6">6</a>  | `𝑠; 𝜌 ⊳ [𝑀 𝑁]`                                    | `[_ (𝑁, 𝜌)]⋅𝑠; 𝜌 ⊳ 𝑀`                |                        |
|  <a href="#7">7</a>  | `𝑠; 𝜌 ⊳ (constr 𝑖 𝑀⋅𝑀*)`                          | `(constr 𝑖 _ (𝑀*, 𝜌))⋅𝑠; 𝜌 ⊳ 𝑀`      |                        |
|  <a href="#8">8</a>  | `𝑠; 𝜌 ⊳ (constr 𝑖 [])`                            | `𝑠 ⊲ 〈constr 𝑖 []〉`                |                        |
|  <a href="#9">9</a>  | `𝑠; 𝜌 ⊳ (case 𝑁 𝑀*)`                              | `(case _ (𝑀*, 𝜌))⋅𝑠; 𝜌 ⊳ 𝑁`          |                        |
| <a href="#10">10</a> | `𝑠; 𝜌 ⊳ (builtin 𝑏)`                              | `𝑠 ⊲ 〈builtin 𝑏 [] 𝛼(𝑏)〉`          |                        |
| <a href="#11">11</a> | `𝑠; 𝜌 ⊳ (error)`                                  | `⬥`                                  |                        |
| <a href="#12">12</a> | `[] ⊲ 𝑉`                                          | `◻𝑉`                                 |                        |
| <a href="#13">13</a> | `[_ (𝑀, 𝜌)]⋅𝑠 ⊲ 𝑉`                                | `[𝑉 _]⋅𝑠; 𝜌 ⊳ 𝑀`                     |                        |
| <a href="#14">14</a> | `[〈lam 𝑥 𝑀 𝜌〉 _]⋅𝑠 ⊲ 𝑉`                         | `𝑠; 𝜌[𝑥 ↦ 𝑉] ⊳ 𝑀`                    |                        |
| <a href="#15">15</a> | `[_ 𝑉]⋅𝑠 ⊲ 〈lam 𝑥 𝑀 𝜌〉`                         | `𝑠; 𝜌[𝑥 ↦ 𝑉] ⊳ 𝑀`                    |                        |
| <a href="#16">16</a> | `[〈builtin 𝑏 𝑉* (𝜄⋅𝜂)〉 _]⋅𝑠 ⊲ 𝑉`                | `𝑠 ⊲ 〈builtin 𝑏 (𝑉⋅𝑉*) 𝜂〉`         | `𝜄` is a term argument |
| <a href="#17">17</a> | `[_ 𝑉]⋅𝑠 ⊲ 〈builtin 𝑏 𝑉* (𝜄⋅𝜂)〉`                | `𝑠 ⊲ 〈builtin 𝑏 (𝑉⋅𝑉*) 𝜂〉`         | `𝜄` is a term argument |
| <a href="#18">18</a> | `[〈builtin 𝑏 𝑉* [𝜄]〉 _]⋅𝑠 ⊲ 𝑉`                  | `𝖤𝗏𝖺𝗅𝖢𝖤𝖪 (𝑠, 𝑏, 𝑉*⋅𝑉)`               | `𝜄` is a term argument |
| <a href="#19">19</a> | `[_ 𝑉]⋅𝑠 ⊲ 〈builtin 𝑏 𝑉* [𝜄]〉`                  | `𝖤𝗏𝖺𝗅𝖢𝖤𝖪 (𝑠, 𝑏, 𝑉*⋅𝑉)`               | `𝜄` is a term argument |
| <a href="#20">20</a> | `(force _)⋅𝑠 ⊲ 〈delay 𝑀 𝜌〉`                     | `𝑠; 𝜌 ⊳ 𝑀`                           |                        |
| <a href="#21">21</a> | `(force _)⋅𝑠 ⊲ 〈builtin 𝑏 𝑉* (𝜄⋅𝜂)〉`            | `𝑠 ⊲ 〈builtin 𝑏 𝑉* 𝜂〉`             | `𝜄` is a type argument |
| <a href="#22">22</a> | `(force _)⋅𝑠 ⊲ 〈builtin 𝑏 𝑉* [𝜄]〉`              | `𝖤𝗏𝖺𝗅𝖢𝖤𝖪 (𝑠, 𝑏, 𝑉*)`                 | `𝜄` is a type argument |
| <a href="#23">23</a> | `(constr 𝑖 𝑉* _ (𝑀⋅𝑀*, 𝜌))⋅𝑠 ⊲ 𝑉`                 | `(constr 𝑖 𝑉*⋅𝑉 _ (𝑀*, 𝜌))⋅𝑠; 𝜌 ⊳ 𝑀` |                        |
| <a href="#24">24</a> | `(constr 𝑖 𝑉 _ ([], 𝜌))⋅𝑠 ⊲ 𝑉`                    | `𝑠 ⊲ 〈constr 𝑖 𝑉*⋅𝑉 〉`             |                        |
| <a href="#25">25</a> | `(case _ (𝑀₀ … 𝑀ₙ , 𝜌))⋅𝑠 ⊲ 〈constr 𝑖 𝑉₁ … 𝑉ₘ〉` | `[_ 𝑉ₘ]⋅⋯⋅[_ 𝑉₁]⋅𝑠; 𝜌 ⊳ 𝑀𝑖`          | `0 ≤ 𝑖 ≤ 𝑛`            |

In this table, `X*` denotes a list of `X`s.
The symbol `⋅` denotes either the cons or snoc operator on lists.

Explanation of the transition rules:

<a id="1" href="#1">**1.**</a> To evaluate a single variable `𝑥`, it looks up its value in the environment `𝜌`, and returns the value if exists.

<a id="2" href="#2">**2.**</a> A constant evaluates to itself, as it is already a value.

<a id="3" href="#3">**3.**</a> A lambda abstraction evaluates to itself, as it is already a value. The
environment is captured in the returned value, for later use in computing
`𝑀`.

<a id="4" href="#4">**4.**</a> A delayed computation evaluates to itself, as it is already a value. The environment is captured in the returned value, for later use in computing `𝑀`.

<a id="5" href="#5">**5.**</a> To evaluate `(force 𝑀)`, it pushes a frame `(force _)` onto the stack, and evaluates `𝑀`.
After `𝑀` is evaluated to a value, the forcing will continue (rules 20, 21 and 22) depending on what the value is.

<a id="6" href="#6">**6.**</a> To evaluate an application `[𝑀 𝑁]`, the machine first evaluates the function `𝑀`, after pushing frame `[_ (𝑁, 𝜌)]` onto the stack. This ensures that once `𝑀` is evaluated, it will proceed to evaluate the argument `𝑁` using the same environment.

<a id="7" href="#7">**7.**</a> To evaluate a constructor application, the machine pushes a frame onto the stack with a hole in place of the first argument.
The frame also stores the remaining arguments along with the current environment.
It then proceeds to evaluate the first argument `𝑀`.

<a id="8" href="#8">**8.**</a> A nullary constructor evaluates to itself, as it is already a value.

<a id="9" href="#9">**9.**</a> To evaluate a `case` expression, the machine pushes a frame onto the stack with a hole in place of the scrutinee.
The frame also stores the branches, `𝑀*`, along with the current environment.
It then proceeds to evaluate the scrutinee `𝑁`.

<a id="10" href="#10">**10.**</a> A builtin function evaluates to itself as it is already a value.

<a id="11" href="#11">**11.**</a> Evaluating `(error)` results in the machine terminating with a failure.

<a id="12" href="#12">**12.**</a> When a value `𝑉` is returned to an empty stack, the machine terminates with success, yielding `𝑉` as final result.

<a id="13" href="#13">**13.**</a> When a value `𝑉` is returned to a stack whose top frame represents an application with the hole in the function position, the frame is replaced with one where the function is `𝑉` and the hole is in the argument position.
The machine then continues by evaluating the argument `𝑀` in the captured environment.

<a id="14" href="#14">**14.**</a> When a value `𝑉` is returned to a stack whose top frame represents an application, where the hole is in the argument position and the function is a lambda abstraction, the machine pops the frame, extends the environment to bind `𝑥` to `𝑉`, and continues by evaluating `𝑀`.
This corresponds to beta reduction.

<a id="15" href="#15">**15.**</a> If the returned value is a lambda abstraction, and the top stack frame represents an application, where the hole is in the function position and the argument is a value, the machine proceeds in the same way as the previous rule.

<a id="16" href="#16">**16.**</a> When a value `𝑉` is returned to a stack whose top frame represents an application where the hole is in the argument position, and the function is a builtin expecting at least two more arguments (since `𝜂` is a non-empty list, `𝜄⋅𝜂` contains at least two elements) and the first is a term argument, the machine pops the frame, and returns an updated `builtin` value.
Because the builtin still requires at least one more argument, the builtin application cannot yet be evaluated and is therefore considered a value.

<a id="17" href="#17">**17.**</a> If the returned value is a builtin application expecting at least two arguments, where the first is a term argument, and the top stack frame represents an application, where the hole is in the function position and the argument is a value, the machine proceeds in the same way as the previous rule.

<a id="18" href="#18">**18.**</a> Like Rule 16, except that the builtin expects exactly one more argument, and it is term argument.
In this case the builtin application is now saturated, so it is evaluated via `𝖤𝗏𝖺𝗅𝖢𝖤𝖪`.
The mechanism of `𝖤𝗏𝖺𝗅𝖢𝖤𝖪` is described later.

<a id="19" href="#19">**19.**</a> Like Rule 17, except that the builtin expects exactly one more argument, and it is term argument.
The machine proceeds in the same way as the previous rule.

<a id="20" href="#20">**20.**</a> If the returned value is a delayed computation, and the top stack frame is a `force` frame, then the `force` and `delay` cancel each other, and the machine continues by evaluating the `𝑀` in the captured environment.

<a id="21" href="#21">**21.**</a> If the returned value is a builtin application expecting at least two arguments, where the first is a type argument, and the top stack frame is a `force` frame, the machine pops the frame, and returns an updated builtin application value, with the first argument removed.
In Plutus, forcing corresponds to applying a type argument.
A builtin application expecting a type argument must be forced before evaluation can continue.

<a id="22" href="#22">**22.**</a> Like Rule 21, except that the builtin excepts exactly one more argument, and it is type argument.
In this case the `force` makes the builtin application saturated, so it is evaluated via `𝖤𝗏𝖺𝗅𝖢𝖤𝖪`.

<a id="23" href="#23">**23.**</a> When a value `𝑉` is returned to a stack whose top frame is a constructor application, with the hole in any argument position except the last (in other words, there is at least one more argument to be evaluated), the machine replaces the frame with one where the hole is moved to the next argument, and proceeds to evaluate the next argument `𝑀` in the captured environment.

<a id="24" href="#24">**24.**</a> Like Rule 23, except that the hole is in the position of the last argument.
In this case, all arguments have been evaluated, so the machine pops the frame and returns a `constr` value.

<a id="25" href="#25">**25.**</a> If the returned value is a constructor application with index `𝑖`, and the top stack frame is a `case` frame, the machine will evaluate the `𝑖`th branch - `𝑀𝑖` - applied to arguments `𝑉ₘ … 𝑉₁` (it is important to note that arguments under `constr` are reversed when passing to a `case` branch - this is done for performance reasons).
To do so, it pops the frame, and pushes `m` frames, each representing an application, with the top frame corresponding to `𝑉ₘ` (the first argument).

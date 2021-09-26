# Commit Based on Function


Author : Skuld Norniern

## Title Template
___
[[State]] [Subject line]

[State] : [ADD, MODIFY, REMOVE, REVERT, IMPROVE, FIX] Pick one and write in UPPERCASE

Subject line :  Write in 40 characters (added functions)

 | : Intentions (optional)

Example 1 :

```

[ADD] Added jit support

```

Example 2 :

```

[FIX] fixed parser, interperter

```

## Body Template
___

[Ident](' '+[File] | [folder])
```
Idents
* : General Comment and Explainatory
+ : Added Files,Folders
- : Removed Files,Folders
/ : Modified Files,Folders

```

Example 1 :

```
* Currently planning to support llvm but cranelift can be supported
/src
    / lib.rs
    + main.rs
    /compiler
        + jit_cranelift.rs
        + jit_inkwell.rs
        / mod.rs
```

Example 2 :

```
* preparimg for JIT
/src
    / lib.rs
    / test.rs
    /compiler
        / interpreter.rs
    /core
        / parser.rs
```
Each tab is equal to 4 space 
## Final Summary

---

Example 1 :

```
[ADD] Added jit support

* Currently planning to support llvm but cranelift can be supported
/src
    / lib.rs
    + main.rs
    /compiler
        + jit_cranelift.rs
        + jit_inkwell.rs
        / mod.rs
```

Example 2 :

```
[FIX] Fixed parser, interperter

* preparimg for JIT
/src
    / lib.rs
    / test.rs
    /compiler
        / interpreter.rs
    /core
        / parser.rs
```

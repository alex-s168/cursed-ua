# cursed.ua
uiua code macro library

```
C ~ "git: github.com/alex-s168/cursed-ua"
```

[Auto-generated docs](https://alex-s168.github.io/cursed-ua/)

## Pattern Matching
```
C~Match!(
  1 + (+1 1) => "a"
| 3 => "b"
| . => "y")
```
This will output `"a"` for `1` and `2`, `"b"` for `3`, and `"y"` in all other cases.

Note that the default case is optional.

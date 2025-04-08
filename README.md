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

## Enums
```
┌─╴ Entity
  Enum!(
    Player = 4  # start counting at 4
  | Sheep       # id 5
  | Horse       # id 6
  | ..Mob       # all other ids are Mobs
  )
└─╴
```

This automatically defines:
- the constants of the enum entries, like this: `Sheep = $Sheep 5`
- `EnumStr` to convert a entry constant to the name string, which can also be un-ed.
- `EnumBin` to convert a entry constant to the value of it, which can also be un-ed.
  you don't have to use this, but this also adds the labels to entries when decoding (un-ed)

Currently the entry with the ".." in front of it assignes to all unassigned IDs, instead of just the following.
this however might be changed in the future.

The names of enum entries should not start with 'Enum'

You can also use more complicated expressions in ID assignments by wrapping them in parenthesis, like `Player = (+Abc 2)`

If you don't assign the first element, it will start counting from zero.

You can skip IDs by assigning elements in the middle.

~ "lib.ua" ~ Enum! Join! Match! ParseMatchArms! SelectBits!

{"1 + 2 + (3+4) => 3"
 "a + b => x"}
ParseMatchArms!$"_>_"
⍤""≍{}
⍤""≍{"1 > 3" " 2 > 3" " (3+4) > 3" "a > x" " b > x"}

{"1 + 2 + (3+4) => 3"
 "a + b => x"
 ". => y"
}
ParseMatchArms!$"_>_"
⍤""≍{" y"}
⍤""≍{"1 > 3" " 2 > 3" " (3+4) > 3" "a > x" " b > x"}

Join!$"_, _" {"a b" "c" "ef"}
⍤""≍"a b, c, ef"

Join!$"_, _" {"a b"}
⍤""≍"a b"

Join!$"_, _" {}
⍤""≍""

M₀ ← Match!(
  1 + (+1 1) => "a"
| 3 => "b"
| . => "y")

⍤""≍"a"M₀1
⍤""≍"a"M₀2
⍤""≍"b"M₀3
⍤""≍"y"M₀4
⍤""≍"y"M₀22

M₁ ← Match!(
  1 + (+1 1) => "a"
| 3 => "b")

⍤""≍"a"M₁1
⍤""≍"a"M₁2
⍤""≍"b"M₁3
⍣(⍤""0◌M₁4|◌)

┌─╴E
  Enum!(
    Generic ← 1
  | Function
  | BinaryOld
  | UuidOld
  | Uuid
  | Md₅
  | EncBSON
  | CompBSON
  | Sensitive
  | Vector
  | ..User
  )
└─╴

E~EnumStr E~Uuid
⍤""≍"Uuid".
°E~EnumStr
⍤""=E~Uuid

4
°E~EnumBin
⍤""=E~UuidOld

500
°E~EnumBin
⍤""=E~User

231
{SelectBits!(3|3|+.1)}
⍤""≍{1_1_1 0_0_1 1_1}

1_1_1 0_0_1 1_1
°SelectBits!(3|3|2)
⍤""≍231

[231 1]
{SelectBits!(3|3|+.1|4|4)}
⍤""≍{1_1_1 0_0_1 1_1 0_0_0_0 0_0_0_1}

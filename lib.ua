Indent‼ ← ⬚0\(⍤"mismatched parenthesis"≥0. ⍣(+1°^0|-1°^1|◌):)

RmTail ← ⍣(↘¯:⟜(=⊣):|◌)

SplitIndent‼ ← (
  ⊜□+1 ↘¯1 =0 Indent‼^0^1.
  ⬚(□"")⧈(□₂⊓(RmTail^0|RmTail^1) °□₂) ¤¤2
)

# macro args: UpIndent DownIndent SplitBy
#
# arr[box[str]] ? str
#
# example: SplitWithIndent‼! @[ @] @, "[1,2,3]"
SplitWithIndent‼! ← (
  SplitIndent‼^0^1
  ≡(□⊂⊙□⊜□≠^2. °□₂)
  °□/⍚⊂
  ↘=0◇⧻⊢.
  ↘¯=0◇⧻⊣.
)

# example: "a + b => x"
# example: "1 + 2 + (3+4) => 3"
# example: ". => x"   (returns 0 and " x")
#
# Cases:or[0|arr[box[str]]] Value:str ? arm:str
ParseMatchArm ← ⍣(
  ⌕"=>".
  +↘¯ 1⊂0. # expand selection to =>
  ⊜□¬
  ⍤""=2⧻.
  ∩°□°[⊙⊙]

  ≍"."▽≠@ ..
  ⨬(SplitWithIndent‼!@(@)@+
    ▽≡◇(¬/×=@ ).
  | 0)
| ⍤"invalid pattern match arm synta"0
)

# macro arg:  T ? str str
#
# default:arr[box[str]] cases:arr[box[T]] ? arr[box[str]]
#
# example:
# ˙ ParseMatchArms!$"_ => _"
ParseMatchArms! ← (
  °□/⍚⊂ ≡⍚(≡{⊙⊙}⊙¤ ParseMatchArm)
  ⍤"only one default arm allowed"≤1⧻.⊃▽(▽¬) ≡◇≍0≡⊢.
  ⊙(≡(□^0∩°□°□°[⊙⊙]))
  ♭≡(⊡1)
)

# invertible try
#
# the inverse of InvTry!(A|B|H) is:
# ˙ try(unA|unB|unH)
InvTry! ←^ $"obv(_|_)":∩($"try(_)"⨬(°□◇⊢|°□/⍚$"_|_")≥2⧻.)⊸≡⍚($"un(_)")

# join arr of boxed strings with ^0
#
# example:  Join!$"_, _"
Join! ← ⍣(""◌°0|°□⊢°1|°□/⍚^0 ◌) ⧻.

# example:
# ˙ Match!(
# ˙   1 + 2 => "a"
# ˙ | 3 => "b"
# ˙ | . => "y")
#
# to put more complicated expression into the match arm cases, surround them with parenthesis:
# ˙ Match!(
# ˙   1 + (+1 1) => "a"
# ˙ | 3 => "b"
# ˙ | . => "y")
# ˙
Match! ←^ $"try(_)" ⨬($"_|assert\"pattern match failure\"0"◌|$"_|(_) pop":°□⊢) ≠0⧻. ⊙Join!$"_|_" ParseMatchArms!($"(_) un(_)":)

┌─╴tests
  {"1 + 2 + (3+4) => 3"
   "a + b => x"}
  ParseMatchArms!$"_>_"
  ⍤""≍{}
  ⍤""≍{"1 > 3" " 2 > 3" "3+4> 3" "a > x" " b > x"}

  {"1 + 2 + (3+4) => 3"
   "a + b => x"
   ". => y"
  }
  ParseMatchArms!$"_>_"
  ⍤""≍{" y"}
  ⍤""≍{"1 > 3" " 2 > 3" "3+4> 3" "a > x" " b > x"}

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
└─╴

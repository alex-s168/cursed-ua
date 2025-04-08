Indent‼ ← ⬚0\(⍤"mismatched parenthesis"≥0. ⍣(+1°^0|-1°^1|◌):)

RmTail  ← ⍣(↘¯:⟜(=⊣):|◌)
RmBegin ← ⍣(↘:⟜(=⊢):|◌)

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

# code mapper of InvTry!
EmitInvTry ← $"obv((_)|(_))":∩($"try(_)"⨬(°□◇⊢|°□/⍚$"_|_")≥2⧻.)⊸≡⍚($"un(_)")

# invertible try
#
# the inverse of InvTry!(A|B|H) is:
# ˙ try(unA|unB|unH)
InvTry! ←^ EmitInvTry

# join arr of boxed strings with ^0
#
# example:  Join!$"_, _"
Join! ← ⍣(""◌°0|°□⊢°1|°□/⍚^0 ◌) ⧻.

# code mapper for Match!
EmitMatch ← $"try(_)" ⨬($"_|assert\"pattern match failure\"0"◌|$"_|(_) pop":°□⊢) ≠0⧻. ⊙Join!$"_|_" ParseMatchArms!($"(_) un(_)":)

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
Match! ←^ EmitMatch

# defines all the enum constants, EnumBin (un-able), and EnumStr (un-able)
#
# example:
# ˙ Enum!(
# ˙   Player = 4  # start counting at 4
# ˙ | Sheep       # id 5
# ˙ | Horse       # id 6
# ˙ | ..Mob       # all other ids are Mobs
# ˙ )
#
# Currently the entry with the ".." in front of it assignes to all unassigned IDs, instead of just the following.
# this however might be changed in the future.
#
# The names of enum entries should not start with 'Enum'
#
# You can also use more complicated expressions in ID assignments by wrapping them in parenthesis, like `Player = (+Abc 2)`
#
# If you don't assign the first element, it will start counting from zero.
#
# You can skip IDs by assigning elements in the middle.
# ˙
Enum! ←^ (
  ≡⍚(
    SplitWithIndent‼!@(@)@=
    ⊂{⊙⊙} ▽≠@ . ⊃(⨬(:0)(:1↘2) =0⬚1⊢⊚⌕"..". °□⊢|↘1)
  )
  # arr[box[ tuple[box[str]|is_rem:box[bol]|overwr:opt[box[int]]]  ]]
  ⬚(□{0 0 "neg1"})\(
    ⨬(□⊂°□⊙(□$"+1(_)"°□◇⊣)|⊙◌)=3◇⧻.:
  )
  ◇↘1

  ⊃(≡⍚(
      °[⊙⊙⊙]
      ◇⊃(
        ⊃($"_ => _" ⊙◌
        | $"_ => _" : ⊙◇⨬$"(_)"("."◌))
      | ⊙◌
        ◇$"\"_\""
        :⊃(
          $"(_) => _"
        | $"(_) => _":
        )
      )
    )
    ∩₄EmitMatch
    $"EnumBin = obv(_|_)"
    ⊙$"EnumStr = obv(_|_)"
  | ≡⍚($"_ = $_ _" . ⊙◌ °{⊙⊙⊙})
    Join!$"_\n_"
  )
  ⇌{⊙⊙⊙}
  Join!$"_\n_"
)

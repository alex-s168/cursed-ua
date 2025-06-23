C ~ "lib.ua"

# by @#7_11_14_17_19_22_23_28_29_31_33
TreeStr ← (
  ⍥(∩/◇⊂⍚(⨬⟜(+₁↯⧻)⊓□∘=1⊸type))∞⟜≡⋅0 # Flat and depth map
  ⍜▽⍚(˜⊂@:)˜⊂0◡⋅⧈>                  # add : thingies
  ⍚˜(⊂↯⊙@ ×2)                       # add padding
  /$"_\n_"                          # Join with lines
)

FmtOpt! ← ⍣("None"°0|$"Some(_)"^0 °□)

JsonOpt! ← ⍣(NaN°0|^0°□)

# as long as ^0 with |1.2 parses, into boxed array
While! ← :◌⍢(⍣(1⊂⊙(□:^0)|0) ◌)∘1[]

# returns string as value that is before X|1.1 parses
Until! ← (
  1""
  ⍢(
    ◌
    # Arr Str
    ⍣(0:⊙^0
    | 1 ⊂ ⊙⊃⊢(↘1)
    )
  )∘
  ◌
  # RemStr Val
)

End ← ""°0⧻

Spaces ← ↘⍣(⊢|0)⊚⊸≠@ 
White  ← ↘⍣(⊢|0)⊚⊸≡(¬/+=" \n\r")
LineBr ← ⍣(°$"\r\n_"|°$"\n_")

°"lol"LineBr "\nlol"
°"lol"LineBr "\r\nlol"

°"aa aa"°"bbb b"Until!LineBr "aa aa\nbbb b"

# Rem Val ? Str
Comment ← (
  ⨬∘↘₁=@ ⊸⊢ ↘1 °@#⊸⊢
  ⊙◌⍣(⊢⊙∘|⋅⧻)⊚+⊃(=@\n|=@\r)..
  ⊃(↘|↙)
)

$ # really coo
$ l
°"really coo" °"\nl"Comment

$ # really ocol
°"really ocol" °""Comment

$ # multi
$ # line
$ # comment
$ notcomment
°{"multi" "line" "comment"}°"notcomment"While!(White Comment White)

IndentGroup‼ ← ⍣(⊃(↘+1)(↘1↙)⊢|[]◌) ⊚=0C~Indent‼^0^1 .

°"hel[l]o "°"world"IndentGroup‼@[@] "[hel[l]o ]world"
°""°"world"IndentGroup‼@[@] "[]world"
°"a"°""IndentGroup‼@[@] "[a]"

# seperator after a field with default value
StructDefaultFieldSep ← ⍣(LineBr|°$"|_")
StructFieldSep        ← ⍣(StructDefaultFieldSep|°$" _")

AssignArrow ← ⍣(°$"=_"|°$"←_")

Char! ← ⊃(↘1|°1/×^0.⊢)

Digit ← Char![⊃(≥@0|≤@9)]
°@4 °"hey" Digit "4hey"

DigitNum ← ⊙(⋕≡°□) While!Digit
°42 °"hey" DigitNum "42hey"

Subscript ← DigitNum ⍣(°$"\_\__"|°$",_")
°123 °"hey" Subscript ",123hey"
°123 °"hey" Subscript "__123hey"

# TODO: real ident probably allows more
# IdentChar ← Char!(+⊃(×⊃(≥@A|≤@Z)|×⊃(≥@a|≤@z)))
IdentStart ← ⍣(⊃↘↙⊢|[]◌) ⊚¬≡₀(⧻regex"\\p{Letter}").
°"a" °"32a" IdentStart "a32a"
°"aeyo" °"32a" IdentStart "aeyo32a"

┌─╴Ident
  |S {Text Subscript}

  Fmt ← ⊂:⍣(""°0|$",_"°□) :°S

  Json ← map{"text" "subscript"} {⊃(S~Text|JsonOpt!∘ S~Subscript)}

  Parse ← (
    ⊙⟜(°1≠0⧻) IdentStart
    ⍣(⊙□ Subscript|⊙0)
    ⊙˜S
  )

  ⍤""≍S"HelloWorld"0 °"32"Parse"HelloWorld32"
  ⍤""≍S"HelloWorld"□32 °"a"Parse"HelloWorld,32a"

  ⍤""≍"Helo" Fmt◌ Parse "Helo"
  ⍤""≍"Helo,32"Fmt◌ Parse "Helo,32"
└─╴

┌─╴Attr
  |S {Path Arg}

  Fmt ← ⊂:⍣(""°0|$"(_)"°□) :°S

  Json ← map{"path" "arg"} {⊃(S~Path|JsonOpt!∘ S~Arg)}

  From ← S⍣(⊙□°$"_(_)"|⊙0)

  ⍤""≍S"A~Bx"0 From"A~Bx"
  ⍤""≍S"A~Bx" □"cool args" From"A~Bx(cool args)"

  ⍤""≍ ⊸(Fmt From) "A~Bx"
  ⍤""≍ ⊸(Fmt From) "A~Bx(cool args)"
└─╴

# outputs list of Attr
# parses:  [hello]   [hello(...)]   [a(x),b(y)]   [a(x)|b(y)]
Attrs ← (
  °@[⊸⊢
  IndentGroup‼@[@]
  ⊙(≡◇Attr~From C~SplitWithIndent‼!@( @) ",|")
)

°"rem"Attrs "[Attr1|Attr2(xyz)|Attr3]rem"
⍤""≍[
  Attr~S "Attr1" 0
  Attr~S "Attr2" □"xyz"
  Attr~S "Attr3" 0
]

⍣(⍤""0 ◌◌ Attrs|◌) "rem"

MultiAttrs ← ⊙(°□∧(□˜⊂∩°□)⊙[]) While!(White Attrs White)

┌─╴StructField
  |S {Default Name Attrs Comments}

  Fmt ← {"Field" {⊃(
        $"Name: \"_\"" Ident~Fmt S~Name
      | $"Default: _" FmtOpt!$"\"_\"" S~Default
      | "Comments" {S~Comments}
      | "Attrs" ≡(□Attr~Fmt) S~Attrs
      )}}

  Json ← (
    {⊃(Ident~Json S~Name
      | JsonOpt!∘ S~Default
      | ≡(□Attr~Json) S~Attrs
      | S~Comments
      )}
    {"name" "default" "attrs" "comments"}
    map
  )

  Parse ← (
    While!(White Comment White)
    MultiAttrs
    Ident~Parse
    ⍣(White
      AssignArrow
      Until!⍣(StructDefaultFieldSep|End)
      ⊙□
    | ⊙0 ⍣(StructFieldSep|End)
    )
    ⊙S
  )

  $ CoolField
  ⍤""≍S0 Ident~S"CoolField" 0 [] [] ◌End Parse

  $ CoolField,23
  ⍤""≍S0 Ident~S"CoolField" □23 [] [] ◌End Parse

  $ # some
  $ #comments
  $ 
  $ CoolField,23
  ⍤""≍S0 Ident~S"CoolField" □23 [] {"some" "comments"} ◌End Parse

  $ CoolField  =  + 1 2
  ⍤""≍S□"  + 1 2" Ident~S"CoolField" 0 [] [] ◌End Parse

  $ CoolField  =  + 1 2| Next
  ⍤""≍S□"  + 1 2" Ident~S"CoolField" 0 [] [] °" Next" Parse

  $ CoolField  =  + 1 2
  $ Next
  ⍤""≍S□"  + 1 2" Ident~S"CoolField" 0 [] [] °"Next" Parse

  $ [Attr4(x)|Attr5]
  $ [Attr3(x)]
  $ CoolField  =  + 1 2
  $ Next
  ⍤""≍S□"  + 1 2" Ident~S"CoolField" 0 [
    Attr~S "Attr4" □"x"
    Attr~S "Attr5" 0
    Attr~S "Attr3" □"x"
  ] [] °"Next" Parse
└─╴

┌─╴DataDefEnt
  |S {Members Attrs Name}

  Fmt ← {"DataDefEnt" {⊃(
        $"Name: _" FmtOpt!($"\"_\"" Ident~Fmt) S~Name
      | "Attrs" ≡(□Attr~Fmt) S~Attrs
      | "Members" ≡⍚StructField~Fmt S~Members
      )}}

  Json ← (
    {⊃(JsonOpt!Ident~Json S~Name
      | ≡⍚StructField~Json S~Members
      | ≡(□Attr~Json) S~Attrs
      )}
    {"name" "members" "attrs"}
    map
  )

  Parse ← (
    ⍣(⊙□Ident~Parse|⊙0)
    White
    MultiAttrs
    ⍣(⍩IndentGroup‼@[@] °@[⊸⊢
    | ⍩IndentGroup‼@{@} °@{⊸⊢
    | ⊙[]
    )
    ⊙(
      While!(White StructField~Parse White)
      ⊙◌ While!(White Comment White)
      ◌End
    )
    ⊙S
  )

  $ User [funny] {
  $   # looong comment
  $   # more comment
  $   [attr(x),attr2]
  $   Name = 3|Pass
  $   Email
  $ } end
  °" end" Parse
  Fmt
  TreeStr
  ◌ # by&pf
└─╴

┌─╴DataDef
  ┌─╴Item
    |S {Ent Comments}

    Fmt ← {"Item" ⊃(
        {"Comments" S~Comments}
      | DataDefEnt~Fmt S~Ent
      )}

    Json ← map{"ent" "comments"} {⊃(DataDefEnt~Json S~Ent|S~Comments)}
  └─╴

  |Struct {Item}
  |Variant {Items}

  Fmt ← ⍣(
    {"Struct"⊙} Item~Fmt°Struct
  | {"Variants" ≡⍚Item~Fmt °Variant}
  )

  Json ← (
    {⊃(⍣("struct" ◌°Struct
        | "variant" ◌°Variant)
      | ⍣(Item~Json°Struct
        | ≡⍚Item~Json°Variant)
      )}
    {"kind" "value"}
    map
  )

  ParseStruct ↚ (
    While!(White Comment White)
    White
    ⊙◌Char!(=@~)
    White
    DataDefEnt~Parse
    ⊙(Struct Item~S)
  )

  ParseVariantEnt ↚ (
    While!(White Comment White)
    White
    ⊙◌Char!(=@|)
    White
    DataDefEnt~Parse
    ⊙Item~S
  )

  ParseVariant ↚ (
    While!ParseVariantEnt
    ⊙Variant
  )

  Parse ← ⍣(ParseStruct|ParseVariant)

  $ # sucker who buys our products
  $ ~ User [funny] {
  $   # looong comment
  $   # more comment
  $   [attr(x),attr2]
  $   Name = 3|Pass
  $   Email
  $ } end
  °" end" Parse
  Fmt
  TreeStr
  ◌ # by&pf

  $ # sucker who buys our products
  $ |Human [idk] {
  $   # looong comment
  $   # more comment
  $   [attr(x),attr2]
  $   Name = 3|Pass
  $   Email
  $ }
  $ 
  $ # ant
  $ |Ant [eee] {Weight| Strength = inf}
  $ end
  °"\nend" Parse
  ⊃(&p json Json
  | Fmt
    TreeStr
    ◌ ⊸&p
  )
└─╴

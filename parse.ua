C ~ "lib.ua"

┌─╴Inp
  ~ {Pos ← 0|Str}

  # Inp Head ? Amount Inp
  Split ← ˜(⍜Inp~Pos+ ⊙: ⊸⍜Inp~Str˜⊃↘↙)

  # Inp Head Span ? Amount Inp
  SplitSpan ← ⊙(:⊂⟜-:Inp~Pos:) ⊸:⊃⋅Inp~Pos Split

  # Inp ? Inp
  MoveToEnd ← °⊸Inp~Pos: Inp"" +⊃(Inp~Pos|⧻Inp~Str)

  ⍤""≍°⊸Pos3 Inp"" MoveToEnd Inp "Axy"

  Inp~Split2 Inp "Hello "
  ⍤""≍°⊸Pos2 Inp "llo "
  ⍤""≍ "He"

  Inp~SplitSpan2 °⊸Pos5 Inp "Hello "
  ⍤""≍°⊸Pos7 Inp "llo "
  ⍤""≍ "He"
  ⍤""≍[5 2]
└─╴

# by @#7_11_14_17_19_22_23_28_29_31_33
TreeStr ← (
  ⍥(∩/◇⊂⍚(⨬⟜(+₁↯⧻)⊓□∘=1⊸type))∞⟜≡⋅0 # Flat and depth map
  ⍜▽⍚(˜⊂@:)˜⊂0◡⋅⧈>                  # add : thingies
  ⍚˜(⊂↯⊙@ ×2)                       # add padding
  /$"_\n_"                          # Join with lines
)

AssNotEmpty ← ⟜(⍤"Array was empty"≠0⧻)

AssHead! ← °^0⊸(⊢Inp~Str)

FmtOpt! ← ⍣("None"°0|$"Some(_)"^0 °□)

JsonOpt! ← ⍣(NaN°0|^0°□)

# as long as ^0 with |1.2 parses, into boxed array
While! ← :◌⍢(⍣(1⊂⊙(□:^0)|0) ◌)∘1[]

# repeats ^0 |1.1 until fails
Rep! ← ⊙◌ While!(⊙0 ^0)

# returns string as value that is before X|1.1 parses
Until! ← (
  1""
  ⍢(
    ◌
    # Arr Inp
    ⍣(0:⊙^0
    | 1 ⊂ ⊙(:Inp~Split1)
    )
  )∘
  ◌
  # RemStr Val
)

End ← ⊸(°0⧻Inp~Str)

# Inp ? Inp
Just! ← |1 ⍣(⊙(⍤""≍^0) Inp~Split(⧻^0)|[]⍤:0$"[_:_] Expected _" :⧻^0 :repr ^0 Inp~Pos ⊙◌)

# Inp Span ... ? Inp ...
Track! ← (
  Inp~Pos.
  ⊙^0
  # OldPos NewInp ...
  ◡⋅Inp~Pos
  # NewPos OldPos NewInp ...
  ⊸(-:)
  # Len OldPos NewInp ...
  ⊂:
  # Span NewInp ...
  :
)

Track!(Inp~Split2) °⊸Inp~Pos5 Inp "Hello "
⍤""≍°⊸Inp~Pos7 Inp "llo "
⍤""≍[5 2]
⍤""≍ "He"

Any! ←^ $"C~CascTry!(_)" /⍚$"_|_" ≡⍚$"(_)"

White  ← |1 Rep!Any!(Just!" "|Just!"\n"|Just!"\r")
LineBr ← |1 Any!(Just!"\r\n"|Just!"\n")

⍤""≍"lol"Inp~Str LineBr Inp"\nlol"
⍤""≍"lol"Inp~Str LineBr Inp"\r\nlol"

°"aa aa"°"bbb b"Inp~Str Until!LineBr Inp"aa aa\nbbb b"

# Rem Val ? Str
Comment ← (
  Just!"#"
  Until!Any!(End|LineBr)
)

$ # really coo
$ l
Inp
°" really coo" °"l"Inp~Str Comment

$ # really ocol
Inp
°" really ocol" °""Inp~Str Comment

$ # multi
$ # line
$ # comment
$ notcomment
Inp
°{" multi" " line" " comment"}°"notcomment" Inp~Str While!(White Comment White)

# Inp InnerStr ? Inp
IndentGroup‼ ← (
  ⊙◌ ⊚=0C~Indent‼^0^1 .Inp~Str.
  ⍣(⊙(↘1↘¯1) ⍩(Inp~Split +1) ⊢|⊃(Inp~MoveToEnd|Inp~Str)◌)
)

°"hel[l]o "°"world" Inp~Str IndentGroup‼@[@] Inp "[hel[l]o ]world"
°""°"world" Inp~Str IndentGroup‼@[@] Inp "[]world"
°"a"°"" Inp~Str IndentGroup‼@[@] Inp"[a]"

# seperator after a field with default value
StructDefaultFieldSep ← Any!(LineBr|Just!"|")
StructFieldSep        ← Any!(StructDefaultFieldSep|Just!" ")

AssignArrow ← |1 Any!(Just!"="|Just!"←")

Digit ← |1.2 ⊙⊸(⍤"Expected digit"×⊃(≥@0|≤@9)) ⊙⊢ Inp~Split1
°@4 °"hey" Inp~Str Digit Inp "4hey"

DigitNum ← ⊙(⋕≡°□) While!Digit
°42 °"hey" Inp~Str DigitNum Inp "42hey"

Subscript ← DigitNum Any!(Just!"__"|Just!",")
°123 °"hey" Inp~Str Subscript Inp ",123hey"
°123 °"hey" Inp~Str Subscript Inp "__123hey"

IdentStart ← ⍣(Inp~Split ⊢|⊃(Inp~MoveToEnd|Inp~Str)◌) ⊙◌ ⊚¬≡₀(⧻regex"\\p{Letter}").Inp~Str.
°"a" °"32a" Inp~Str IdentStart Inp "a32a"
°"aeyo" °"32a" Inp~Str IdentStart Inp "aeyo32a"

┌─╴Ident
  |S {Text Subscript}

  Fmt ← ⊂:⍣(""°0|$",_"°□) :°S

  Json ← map{"text" "subscript"} {⊃(S~Text|JsonOpt!∘ S~Subscript)}

  Parse ← |1.2 (
    ⊙AssNotEmpty IdentStart
    ⍣(⊙□ Subscript|⊙0)
    ⊙˜S
  )

  ⍤""≍S"HelloWorld"0 °"32" Inp~Str Parse Inp"HelloWorld32"
  ⍤""≍S"HelloWorld"□32 °"a" Inp~Str Parse Inp"HelloWorld,32a"

  ⍤""≍"Helo" Fmt◌ Parse Inp "Helo"
  ⍤""≍"Helo,32"Fmt◌ Parse Inp "Helo,32"
└─╴

┌─╴Path
  |S {Segments}

  Fmt ← ≡⍚Ident~Fmt°S

  Json ← map{"segments"} {≡⍚Ident~Json S~Segments}

  Parse ← |1.2 (
    ⊙□Ident~Parse
    While!(
      Just!"~"
      White
      Ident~Parse
    )
    ⊙(S˜⊂)
  )

  ⍤""≍S {◌End Ident~Parse Inp"Ax" ◌End Ident~Parse Inp"By" ◌End Ident~Parse Inp"Cz"} ◌End Parse Inp "Ax~By~Cz"
└─╴

┌─╴Attr
  |S {Arg Calling Path}

  Json ← map{"path" "calling" "arg"} {⊃(Path~Json S~Path|⨬(False|True) S~Calling|JsonOpt!∘ S~Arg)}

  # too lazy to write fmt func
  Fmt ← json Json

  # Pa~Th  or  Pa~Th(arg)  or  Pa~Th!  or  Pa~Th!(arg)
  Parse ← |1.2 (
    Path~Parse
    ⍣(|1.2 ⊙True Just!"!"|⊙False)
    ⍣(|1.2 AssHead!@(
           IndentGroup‼@(@)
           ⊙□
    | ⊙0)
    ⊙S
  )

  ⍤""≍S0 False◌End Path~Parse Inp"A~Bx" °"69" Inp~Str Parse Inp"A~Bx69"
  ⍤""≍S□"cool arg" False◌End Path~Parse Inp"A~Bx" °"69" Inp~Str Parse Inp"A~Bx(cool arg)69"
└─╴

# outputs list of Attr
# parses:  ^hello  ^hello(arg) ^hello!  ^hello!(...)
Attrs ← |1.2 (
  Just!"^"
  Attr~Parse
  ⊙[∘]
)

°"rem" Inp~Str Attrs Inp "^funny~attr!(arg)rem"
⍤""≍[◌Attr~Parse Inp"funny~attr!(arg)"]

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
      Until!Any!(StructDefaultFieldSep|End)
      ⊙□
    | ⊙0 Any!(StructFieldSep|End)
    )
    ⊙S
  )

  $ CoolField
  Inp
  ⍤""≍S0 Ident~S"CoolField" 0 [] [] ◌End Parse

  $ CoolField,23
  Inp
  ⍤""≍S0 Ident~S"CoolField" □23 [] [] ◌End Parse

  $ # some
  $ #comments
  $ 
  $ CoolField,23
  Inp
  ⍤""≍S0 Ident~S"CoolField" □23 [] {" some" "comments"} ◌End Parse

  $ CoolField  =  + 1 2
  Inp
  ⍤""≍S□"  + 1 2" Ident~S"CoolField" 0 [] [] ◌End Parse

  $ CoolField  =  + 1 2| Next
  Inp
  ⍤""≍S□"  + 1 2" Ident~S"CoolField" 0 [] [] °" Next" Inp~Str Parse

  $ CoolField  =  + 1 2
  $ Next
  Inp
  ⍤""≍S□"  + 1 2" Ident~S"CoolField" 0 [] [] °"Next" Inp~Str Parse

  $ ^Attr(x) ^My~Module~Attr
  $ ^Attr,3!(x)
  $ CoolField  =  + 1 2
  $ Next
  Inp
  ⍤""≍S□"  + 1 2" Ident~S"CoolField" 0 [
    ◌Attr~Parse Inp"Attr(x)"
    ◌Attr~Parse Inp"My~Module~Attr"
    ◌Attr~Parse Inp"Attr,3!(x)"
  ] [] °"Next" Inp~Str Parse
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
    ⍣(⍩IndentGroup‼@[@] AssHead!@[
    | ⍩IndentGroup‼@{@} AssHead!@{
    | ⊙[]
    )
    ⊙(
      Inp
      While!(White StructField~Parse White)
      ⊙◌ While!(White Comment White)
      ◌End
    )
    ⊙S
  )

  $ User ^funny! {
  $   # looong comment
  $   # more comment
  $   ^attr(x) ^pa~th~attr
  $   Name = 3|Pass
  $   Email
  $ } end
  Inp
  °" end" Inp~Str Parse
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
    Just!"~"
    White
    DataDefEnt~Parse
    ⊙(Struct Item~S)
  )

  ParseVariantEnt ↚ (
    While!(White Comment White)
    White
    Just!"|"
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
  $ ~ User ^funny! {
  $   # looong comment
  $   # more comment
  $   ^attr(x) ^attr,2
  $   Name = 3|Pass
  $   Email
  $ } end
  Inp
  °" end" Inp~Str Parse
  Fmt
  TreeStr
  ◌ # by&pf

  $ # sucker who buys our products
  $ |Human ^idk {
  $   # looong comment
  $   # more comment
  $   ^attr!(x) ^attr,2
  $   Name = 3|Pass
  $   Email
  $ }
  $ 
  $ # ant
  $ |Ant ^eee {Weight| Strength = inf}
  $ end
  Inp
  °"\nend" Inp~Str Parse
  ⊃(&p json Json
  | Fmt
    TreeStr
    ◌ ⊸&p
  )
└─╴
